from flask import Flask, render_template

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
    from models import Endpoints
    endpoints = Endpoints.query.filter_by(device_id=device_id).all()
    return render_template('device_details.html', device=device, endpoints=endpoints)

@app.route('/optical-paths')
def optical_paths():
    from models import OpticalPath
    optical_paths_list = OpticalPath.query.all()
    return render_template('optical_paths.html', optical_paths=optical_paths_list)

@app.route('/optical-path-details/<uuid:path_id>')
def optical_path_details(path_id):
    from models import OpticalPath, OpticalPathLinks
    path = OpticalPath.query.get_or_404(path_id)
    links = OpticalPathLinks.query.filter_by(optical_path_uuid=path_id).all()
    return render_template('optical_path_links.html', path=path, links=links)

@app.route('/rsa-computation')
def rsa_computation_route():
    from rsa import rsa_computation
    result = rsa_computation()
    return result

@app.route('/topology')
def topology():
    from topo import create_topo
    create_topo()
    return render_template('index.html', message="Topology generated!", image="topology2_1_and_1_1.png")

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0')
