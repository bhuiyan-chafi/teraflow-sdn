from flask import Flask, render_template, request, redirect, url_for
import logging
import os
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy import text
from models import db, Devices
from enums.OpticalBands import FrequencyMeasurementUnit

# Configure logging
logger = logging.getLogger(__name__)

# Constants
_DISTANCE = 1000
_QPSK = "QPSK"
_8PSK = "8PSK"
_16QAM = "16QAM"


app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = os.environ.get(
    'DATABASE_URL', 'sqlite:///local.db')
db.init_app(app)

with app.app_context():
    db.create_all()


# Custom Jinja2 filters for frequency conversion using FrequencyMeasurementUnit enum
@app.template_filter('hz_to_thz')
def hz_to_thz_filter(value_hz):
    """Convert Hz to THz using FrequencyMeasurementUnit enum"""
    if value_hz is None:
        return None
    return value_hz / FrequencyMeasurementUnit.THz.value


@app.template_filter('hz_to_ghz')
def hz_to_ghz_filter(value_hz):
    """Convert Hz to GHz using FrequencyMeasurementUnit enum"""
    if value_hz is None:
        return None
    return value_hz / FrequencyMeasurementUnit.GHz.value


@app.template_filter('format_hz')
def format_hz_filter(value_hz):
    """Format Hz with thousand separators"""
    if value_hz is None:
        return 'N/A'
    return "{:,.0f}".format(value_hz)


@app.route('/')
def index():
    try:
        db.session.execute(text('SELECT 1'))
        db_status = "Connected to PostgreSQL!"
    except Exception as e:
        db_status = f"Database connection failed: {str(e)}"

    return render_template('index.html', message=f"Hello! I am CHAFI working on RSA (routing and spectrum allocation) project. Under my professor Alessio Giorgetti, UniPi. [{db_status}]")


@app.route('/devices')
def devices():
    devices_list = Devices.query.all()
    return render_template('devices.html', devices=devices_list)


@app.route('/device-details/<uuid:device_id>')
def device_details(device_id):
    device = Devices.query.get_or_404(device_id)
    # Access endpoints via relationship if defined, or query manually
    # Since we didn't define relationship in models yet, we query manually
    from models import Endpoint
    endpoints = Endpoint.query.filter_by(device_id=device_id).all()
    return render_template('device_details.html', device=device, endpoints=endpoints)


@app.route('/endpoint-details/<uuid:endpoint_id>')
def endpoint_details(endpoint_id):
    from models import Endpoint
    from helpers import OpticalBandHelper, SpectrumHelper
    from enums.ITUStandards import ITUStandards

    endpoint = Endpoint.query.get_or_404(endpoint_id)
    device = Devices.query.get_or_404(endpoint.device_id)

    # Detect the optical band based on endpoint's frequency range
    band_info = None
    slot_table = []
    slot_granularity = ITUStandards.SLOT_GRANULARITY.value

    if endpoint.min_frequency and endpoint.max_frequency:
        band_info = OpticalBandHelper.detect_band(
            endpoint.min_frequency,
            endpoint.max_frequency
        )

        # Build spectrum slot table if band detected
        if band_info:
            slot_table = SpectrumHelper.build_spectrum_slot_table(
                endpoint, band_info)

    return render_template('device_endpoint_frequency_view.html',
                           endpoint=endpoint,
                           device=device,
                           band_info=band_info,
                           slot_table=slot_table,
                           slot_granularity=slot_granularity)


def optical_links():
    from models import OpticalLink
    from helpers import TopologyHelper
    links = OpticalLink.query.all()
    processed_links = TopologyHelper.process_optical_links(links)
    return render_template('optical_links.html', links=processed_links)


@app.route('/topology')
def topology():
    from topology import generate_topology_graph
    image_file = generate_topology_graph()
    return render_template('topology.html', image=image_file)


@app.route('/path-finder', methods=['GET', 'POST'])
def path_finder():
    from models import Devices
    from topology import find_paths

    if request.method == 'POST':
        src_device = request.form.get('src_device')
        src_port = request.form.get('src_port')
        dst_device = request.form.get('dst_device')
        dst_port = request.form.get('dst_port')
        bandwidth = request.form.get('bandwidth')

        paths = find_paths(src_device, src_port,
                           dst_device, dst_port, bandwidth)

        return render_template('paths.html',
                               dijkstra_paths=paths['dijkstra'],
                               all_paths=paths['all_paths'],
                               src_device=src_device,
                               src_port=src_port,
                               dst_device=dst_device,
                               dst_port=dst_port,
                               bandwidth=bandwidth)

    devices = Devices.query.all()
    return render_template('path_finder.html', devices=devices)


@app.route('/rsa-path', methods=['GET', 'POST'])
def rsa_path():
    from topology import perform_rsa_for_path

    if request.method == 'POST':
        link_ids = request.form.getlist('link_ids')
        bandwidth = request.form.get('bandwidth')

        rsa_res = perform_rsa_for_path(link_ids, bandwidth)

        return render_template('rsa_path.html',
                               rsa=rsa_res,
                               link_ids=link_ids,
                               bandwidth=bandwidth)

    return redirect(url_for('path_finder'))


@app.route('/acquire-path', methods=['POST'])
def acquire_path():
    from helpers import TopologyHelper

    link_ids = request.form.getlist('link_ids')
    mask_str = request.form.get('mask')

    logger.info(
        f"[Acquire Path] Targeted request. links={link_ids}, mask={mask_str}")

    if not link_ids or not mask_str:
        return "Missing link IDs or mask for acquisition.", 400

    try:
        mask = int(mask_str)
        # Directly commit using the pre-calculated mask as requested
        success = TopologyHelper.commit_slots(link_ids, mask)

        if success:
            logger.info(
                "[Acquire Path] Slots acquired successfully. Redirecting...")
            return redirect(url_for('optical_links'))
        else:
            return "Failed to commit slots to database.", 500
    except ValueError:
        return "Invalid mask value.", 400


if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0')
