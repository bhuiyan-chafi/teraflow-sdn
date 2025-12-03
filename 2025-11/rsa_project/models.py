import uuid
from datetime import datetime
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy.dialects.postgresql import UUID

db = SQLAlchemy()

class Devices(db.Model):
    __tablename__ = 'devices'
    
    id = db.Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    name = db.Column(db.String(100), nullable=False, unique=True)
    type = db.Column(db.String(50), nullable=False)
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    updated_at = db.Column(db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
    
    endpoints = db.relationship('Endpoint', backref='device', lazy=True)

    def __repr__(self):
        return f"<Device {self.name} ({self.type})>"

class Endpoint(db.Model):
    __tablename__ = 'endpoints'
    
    id = db.Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    device_id = db.Column(UUID(as_uuid=True), db.ForeignKey('devices.id'), nullable=False)
    name = db.Column(db.String(50), nullable=False)
    type = db.Column(db.String(50), nullable=False)
    otn_type = db.Column(db.String(50), nullable=False)
    in_use = db.Column(db.Boolean, default=False)
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    updated_at = db.Column(db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)

    def __repr__(self):
        return f"<Endpoint {self.name} ({self.type})>"

class OpticalLink(db.Model):
    __tablename__ = 'optical_links'
    
    id = db.Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    name = db.Column(db.String(100), nullable=False)
    src_device_id = db.Column(UUID(as_uuid=True), db.ForeignKey('devices.id'), nullable=False)
    dst_device_id = db.Column(UUID(as_uuid=True), db.ForeignKey('devices.id'), nullable=False)
    src_endpoint_id = db.Column(UUID(as_uuid=True), db.ForeignKey('endpoints.id'), nullable=False)
    dst_endpoint_id = db.Column(UUID(as_uuid=True), db.ForeignKey('endpoints.id'), nullable=False)
    status = db.Column(db.String(50), nullable=False)
    c_slot = db.Column(db.Numeric(scale=0), nullable=False, default=0)
    l_slot = db.Column(db.Numeric(scale=0), nullable=False, default=0)
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    updated_at = db.Column(db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)

    src_device = db.relationship('Devices', foreign_keys=[src_device_id])
    dst_device = db.relationship('Devices', foreign_keys=[dst_device_id])
    src_endpoint = db.relationship('Endpoint', foreign_keys=[src_endpoint_id])
    dst_endpoint = db.relationship('Endpoint', foreign_keys=[dst_endpoint_id])

    def __repr__(self):
        return f"<OpticalLink {self.id} ({self.status})>"
