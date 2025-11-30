import uuid
from datetime import datetime
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy.dialects.postgresql import UUID

db = SQLAlchemy()

class Devices(db.Model):
    __tablename__ = 'devices'
    
    id = db.Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    name = db.Column(db.String(100), nullable=False)
    type = db.Column(db.String(50), nullable=False)
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    updated_at = db.Column(db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)

    def __repr__(self):
        return f"<Device {self.name} ({self.type})>"

class Endpoints(db.Model):
    __tablename__ = 'endpoints'
    
    id = db.Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    device_id = db.Column(UUID(as_uuid=True), db.ForeignKey('devices.id'), nullable=False)
    name = db.Column(db.String(50), nullable=False)
    type = db.Column(db.String(50), nullable=False)
    otn_type = db.Column(db.String(50), nullable=False)
    in_use = db.Column(db.Boolean, default=False)
    c_slot = db.Column(db.BigInteger, nullable=False)
    l_slot = db.Column(db.BigInteger, nullable=False)
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    updated_at = db.Column(db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)

    def __repr__(self):
        return f"<Endpoint {self.name} ({self.type})>"

class OpticalPath(db.Model):
    __tablename__ = 'optical_paths'
    
    id = db.Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    src_device_id = db.Column(UUID(as_uuid=True), db.ForeignKey('devices.id'), nullable=False)
    dst_device_id = db.Column(UUID(as_uuid=True), db.ForeignKey('devices.id'), nullable=False)
    src_endpoint_id = db.Column(UUID(as_uuid=True), db.ForeignKey('endpoints.id'), nullable=False)
    dst_endpoint_id = db.Column(UUID(as_uuid=True), db.ForeignKey('endpoints.id'), nullable=False)
    status = db.Column(db.String(50), nullable=False)
    c_slot = db.Column(db.BigInteger, nullable=False)
    l_slot = db.Column(db.BigInteger, nullable=False)
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    updated_at = db.Column(db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)

    src_device = db.relationship('Devices', foreign_keys=[src_device_id])
    dst_device = db.relationship('Devices', foreign_keys=[dst_device_id])
    src_endpoint = db.relationship('Endpoints', foreign_keys=[src_endpoint_id])
    dst_endpoint = db.relationship('Endpoints', foreign_keys=[dst_endpoint_id])

    def __repr__(self):
        return f"<OpticalPath {self.id} ({self.status})>"

class OpticalPathLinks(db.Model):
    __tablename__ = 'optical_path_links'
    
    id = db.Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    optical_path_uuid = db.Column(UUID(as_uuid=True), db.ForeignKey('optical_paths.id'), nullable=False)
    src_device_id = db.Column(UUID(as_uuid=True), db.ForeignKey('devices.id'), nullable=False)
    dst_device_id = db.Column(UUID(as_uuid=True), db.ForeignKey('devices.id'), nullable=False)
    src_endpoint_id = db.Column(UUID(as_uuid=True), db.ForeignKey('endpoints.id'), nullable=False)
    dst_endpoint_id = db.Column(UUID(as_uuid=True), db.ForeignKey('endpoints.id'), nullable=False)
    status = db.Column(db.String(50), nullable=False)
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    updated_at = db.Column(db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)

    src_device = db.relationship('Devices', foreign_keys=[src_device_id])
    dst_device = db.relationship('Devices', foreign_keys=[dst_device_id])
    src_endpoint = db.relationship('Endpoints', foreign_keys=[src_endpoint_id])
    dst_endpoint = db.relationship('Endpoints', foreign_keys=[dst_endpoint_id])

    def __repr__(self):
        return f"<OpticalPathLink {self.id} ({self.status})>"
