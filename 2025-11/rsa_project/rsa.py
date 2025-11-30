import logging
from models import Devices, Endpoints, OpticalPath, OpticalPathLinks
from sqlalchemy import and_

# Configure logger
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

def int_to_bitmap(value, length=35):
    """Converts an integer to a binary string bitmap."""
    return format(value, f'0{length}b')

def rsa_computation():
    logger.info("Starting RSA Computation...")

    # --- CONSTANTS ---
    # Updated with user's values
    REQUESTED_SOURCE_DEVICE_ID = "d0e50594-0466-4d56-a402-01fb3a2e6a74"
    REQUESTED_SOURCE_PORT_ID = "85ec37a4-4afa-41a1-9dbc-dd8ab731f3b6"
    REQUESTED_DEST_DEVICE_ID = "44e96f93-3f5c-4c9e-8d31-bc82f05a210d"
    REQUESTED_DEST_PORT_ID = "8e08780f-6f04-4e30-8073-4c0947f97960"
    REQUESTED_SLOTS = 7
    
    logger.info(f"Request: SrcDev={REQUESTED_SOURCE_DEVICE_ID}, SrcPort={REQUESTED_SOURCE_PORT_ID}")
    logger.info(f"Request: DstDev={REQUESTED_DEST_DEVICE_ID}, DstPort={REQUESTED_DEST_PORT_ID}")
    logger.info(f"Request: Slots={REQUESTED_SLOTS}")

    # --- STEP 1: Endpoint Intersection (Source & Dest) ---
    logger.info("--- Step 1: Calculating Endpoint Intersection ---")
    
    # 1.1 Source Device Ports
    source_ports = Endpoints.query.filter_by(device_id=REQUESTED_SOURCE_DEVICE_ID).all()
    if not source_ports:
        logger.error("No ports found for source device.")
        return {"status": "error", "message": "Source ports not found"}
    
    # Check if requested source port is in_use
    source_port_obj = Endpoints.query.get(REQUESTED_SOURCE_PORT_ID)
    if source_port_obj:
        logger.info(f"DEBUG: Source Port {source_port_obj.name} (ID: {source_port_obj.id}) in_use status: {source_port_obj.in_use}")
        if source_port_obj.in_use:
            logger.warning(f"Source Port {source_port_obj.name} is already IN USE.")
            return {"status": "failure", "message": "Source port is already in use"}
    else:
        logger.error(f"DEBUG: Source Port ID {REQUESTED_SOURCE_PORT_ID} not found in DB.")

    logger.info(f"Found {len(source_ports)} ports on source device.")
    source_intersection = -1 # All 1s initially
    for p in source_ports:
        if source_intersection == -1:
            source_intersection = p.c_slot
        else:
            source_intersection &= p.c_slot
        logger.info(f"Source Port {p.name}: {int_to_bitmap(p.c_slot)}")
            
    logger.info(f"Source Device Intersection: {int_to_bitmap(source_intersection)}")

    # 1.2 Destination Device Ports
    dest_ports = Endpoints.query.filter_by(device_id=REQUESTED_DEST_DEVICE_ID).all()
    if not dest_ports:
        logger.error("No ports found for destination device.")
        return {"status": "error", "message": "Destination ports not found"}
        
    # Check if requested dest port is in_use
    dest_port_obj = Endpoints.query.get(REQUESTED_DEST_PORT_ID)
    if dest_port_obj and dest_port_obj.in_use:
        logger.warning(f"Destination Port {dest_port_obj.name} is already IN USE.")
        return {"status": "failure", "message": "Destination port is already in use"}

    logger.info(f"Found {len(dest_ports)} ports on destination device.")
    dest_intersection = -1
    for p in dest_ports:
        if dest_intersection == -1:
            dest_intersection = p.c_slot
        else:
            dest_intersection &= p.c_slot
        logger.info(f"Dest Port {p.name}: {int_to_bitmap(p.c_slot)}")
            
    logger.info(f"Dest Device Intersection:   {int_to_bitmap(dest_intersection)}")

    # 1.3 Endpoint Intersection
    endpoint_intersection = source_intersection & dest_intersection
    endpoint_bitmap = int_to_bitmap(endpoint_intersection)
    logger.info(f"Endpoint Intersection:      {endpoint_bitmap}")
    
    # 1.4 Check for contiguous block in endpoints
    count = 0
    has_valid_endpoint_slots = False
    for bit in endpoint_bitmap:
        if bit == '1':
            count += 1
            if count >= REQUESTED_SLOTS:
                has_valid_endpoint_slots = True
                break
        else:
            count = 0
            
    if not has_valid_endpoint_slots:
        logger.warning(f"Failure: Source and Destination devices do not have {REQUESTED_SLOTS} contiguous common slots.")
        return {"status": "failure", "message": "Endpoints cannot support requested slots"}
    else:
        logger.info("Endpoints have sufficient common slots. Proceeding to path check...")

    # --- STEP 2: Global Intersection (Path) ---
    logger.info("--- Step 2: Calculating Global Intersection (Path) ---")

    # 2.1 Fetch Path
    path = OpticalPath.query.filter_by(
        src_device_id=REQUESTED_SOURCE_DEVICE_ID,
        dst_device_id=REQUESTED_DEST_DEVICE_ID
    ).first()
    
    if not path:
        logger.error("No optical path found between source and destination.")
        return {"status": "error", "message": "Path not found"}
        
    links = OpticalPathLinks.query.filter_by(optical_path_uuid=path.id).all()
    logger.info(f"Found {len(links)} links in the path.")
    
    # 2.2 Intersect with all path ports
    global_intersection = endpoint_intersection
    
    path_link_ports = []
    for link in links:
        src_ep = link.src_endpoint
        dst_ep = link.dst_endpoint
        
        # Add to list for potential update later
        path_link_ports.append({"obj": src_ep, "device": link.src_device.name, "port": src_ep.name})
        path_link_ports.append({"obj": dst_ep, "device": link.dst_device.name, "port": dst_ep.name})
        
        # Update intersection
        global_intersection &= src_ep.c_slot
        global_intersection &= dst_ep.c_slot
        
        logger.info(f"Link Port {link.src_device.name}:{src_ep.name} c_slot: {int_to_bitmap(src_ep.c_slot)}")
        logger.info(f"Link Port {link.dst_device.name}:{dst_ep.name} c_slot: {int_to_bitmap(dst_ep.c_slot)}")
        
    global_bitmap = int_to_bitmap(global_intersection)
    logger.info(f"Global Path Intersection:   {global_bitmap}")

    # 2.3 Find contiguous block in Global Intersection (LSB First)
    count = 0
    found_start_index = -1
    
    # Iterate backwards (LSB preference)
    for i in range(len(global_bitmap) - 1, -1, -1):
        if global_bitmap[i] == '1':
            count += 1
            if count == REQUESTED_SLOTS:
                found_start_index = i
                break
        else:
            count = 0
            
    if found_start_index != -1:
        logger.info(f"Success: Found contiguous block of {REQUESTED_SLOTS} slots starting at index {found_start_index} (LSB-first)")
        
        # --- RESERVATION LOGIC ---
        from models import db
        
        reservation_mask = 0
        for i in range(found_start_index, found_start_index + REQUESTED_SLOTS):
            bit_power = 35 - 1 - i
            reservation_mask += (1 << bit_power)
            
        logger.info(f"Reservation Mask: {reservation_mask} (Bitmap: {int_to_bitmap(reservation_mask)})")
        
        try:
            updated_ports = set()
            
            # Update all ports in the path
            for p in path_link_ports:
                endpoint = p['obj']
                if endpoint.id not in updated_ports:
                    endpoint.c_slot = endpoint.c_slot - reservation_mask
                    endpoint.in_use = True
                    updated_ports.add(endpoint.id)
                    logger.info(f"Reserved slots on Device {p['device']} Port {p['port']}. New c_slot: {endpoint.c_slot}. Marked as IN USE.")
            
            db.session.commit()
            logger.info("Database updated successfully.")
            return {"status": "success", "message": "Slots reserved successfully"}
            
        except Exception as e:
            db.session.rollback()
            logger.error(f"Failed to update database: {str(e)}")
            return {"status": "error", "message": f"Database update failed: {str(e)}"}

    else:
        logger.warning("Failure: The requested slots are NOT available along the path (Global Check).")
        return {"status": "failure", "message": "Slots not available on path"}
