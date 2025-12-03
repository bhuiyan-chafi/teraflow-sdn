from flask import Flask, render_template, request

import os
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy import text
from models import db, Devices

# Constants
_DISTANCE = 1000
_QPSK = "QPSK"
_8PSK = "8PSK"
_16QAM = "16QAM"


app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = os.environ.get('DATABASE_URL', 'sqlite:///local.db')
db.init_app(app)

with app.app_context():
    db.create_all()

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

@app.route('/optical-links')
def optical_links():
    from models import OpticalLink
    links = OpticalLink.query.all()
    return render_template('optical_links.html', links=links)

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
        
        paths = find_paths(src_device, src_port, dst_device, dst_port, bandwidth)
        
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


if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0')
