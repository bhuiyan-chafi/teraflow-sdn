import logging
import math
import networkx as nx

# Configure logging
logger = logging.getLogger(__name__)

# OTN Types
OTN_TYPE_OCH = "OCH"
OTN_TYPE_OMS = "OMS"
OTN_TYPE_MISMATCH = "OTN_TYPE_MISMATCH"

class TopologyHelper:
    @staticmethod
    def int_to_bitmap(value, length=35):
        """Converts an integer to a binary string bitmap."""
        # Handle cases where value might be None or not an int
        if value is None:
            return "0" * length
        try:
            val_int = int(value)
            return format(val_int, f'0{length}b')
        except (ValueError, TypeError):
            return "0" * length

    @staticmethod
    def expand_path(node_path, graph_to_use, src_port, dst_port):
        """
        Converts a node path (list of device names) into a detailed link path.
        Handles parallel links and port constraints.
        """
        valid_edge_paths = []
        
        def backtrack(index, current_edge_path):
            if index == len(node_path) - 1:
                # Check validity of the full path
                is_valid = True
                for link in current_edge_path:
                    if link['status'] != 'FREE':
                        is_valid = False
                        break
                
                valid_edge_paths.append({
                    'links': list(current_edge_path),
                    'is_valid': is_valid
                })
                return

            u = node_path[index]
            v = node_path[index+1]
            
            # Find all edges between u and v in the specified graph
            if not graph_to_use.has_edge(u, v):
                return
                
            edges = graph_to_use[u][v] # dict of key -> attributes
            
            for key, attr in edges.items():
                # Determine ports based on direction
                if attr['original_src'] == u and attr['original_dst'] == v:
                    out_port = attr['src_port']
                    in_port = attr['dst_port']
                elif attr['original_src'] == v and attr['original_dst'] == u:
                    out_port = attr['dst_port']
                    in_port = attr['src_port']
                else:
                    continue

                # Check constraints
                if index == 0 and src_port and out_port != src_port:
                    continue
                
                if index == len(node_path) - 2 and dst_port and in_port != dst_port:
                    continue
                    
                # Add to path
                current_edge_path.append({
                    'id': str(key), # Unique ID for the link (UUID as string)
                    'src': u,
                    'dst': v,
                    'src_port': out_port,
                    'dst_port': in_port,
                    'name': attr['name'],
                    'status': attr['status'],
                    'otn_type': attr.get('otn_type'), # NEW: Include OTN Type
                    'c_slot': attr['c_slot'] # Include c_slot for RSA
                })
                
                backtrack(index + 1, current_edge_path)
                current_edge_path.pop()

        # In expand_path, we compute all combinations of physical links
        # We need to correctly calculate is_valid for each based on OTN-aware logic
        valid_edge_paths = []
        
        # Internal backtrack above populates this list, but we need to define it differently now
        # Actually, let's redefine the validity check INSIDE the backtrack loop
        
        def backtrack_v2(index, current_edge_path):
            if index == len(node_path) - 1:
                # NEW Path Validity Logic
                is_valid = True
                for link in current_edge_path:
                    otn = link['otn_type']
                    status = link['status']
                    
                    if otn == 'OCH' and status != 'FREE':
                        is_valid = False
                        break
                    elif otn == 'OMS' and status == 'FULL':
                        is_valid = False
                        break
                
                valid_edge_paths.append({
                    'links': list(current_edge_path),
                    'is_valid': is_valid
                })
                return

            u = node_path[index]
            v = node_path[index+1]
            if not graph_to_use.has_edge(u, v): return
            edges = graph_to_use[u][v]
            
            for key, attr in edges.items():
                # Port matching logic...
                if attr['original_src'] == u and attr['original_dst'] == v:
                    out_port, in_port = attr['src_port'], attr['dst_port']
                elif attr['original_src'] == v and attr['original_dst'] == u:
                    out_port, in_port = attr['dst_port'], attr['src_port']
                else: continue

                if index == 0 and src_port and out_port != src_port: continue
                if index == len(node_path) - 2 and dst_port and in_port != dst_port: continue
                    
                current_edge_path.append({
                    'id': str(key),
                    'src': u,
                    'dst': v,
                    'src_port': out_port,
                    'dst_port': in_port,
                    'name': attr['name'],
                    'status': attr['status'],
                    'otn_type': attr.get('otn_type'),
                    'c_slot': attr['c_slot']
                })
                backtrack_v2(index + 1, current_edge_path)
                current_edge_path.pop()

        backtrack_v2(0, [])
        return valid_edge_paths

    @staticmethod
    def rsa_bitmap_pre_compute(path_obj, graph):
        """
        Computes the available spectrum bitmap by intersecting with ALL parallel links
        for each hop in the path. Returns the final bitmap, total slots, and a trace of steps.
        """
        if not path_obj['links']:
            return 0, 0, []
            
        # Initialize with the first link's c_slot (we'll start with all 1s instead for consistency)
        total_slots = 35 
        current_bitmap = (1 << total_slots) - 1
        
        trace_steps = []
        
        logger.info(f"[RSA Pre-Compute] Initial Bitmap (All Free): {current_bitmap:b} (Length: {total_slots})")
        
        # Iterate through each hop in the path
        for i, link in enumerate(path_obj['links']):
            u, v = link['src'], link['dst']
            hop_label = f"{u} -> {v}"
            hop_links = []
            hop_intersection = (1 << total_slots) - 1
            
            # Find all parallel edges between u and v
            if graph.has_edge(u, v):
                parallel_edges = graph[u][v]
                for key, attr in parallel_edges.items():
                    p_name = attr.get('name', 'unknown')
                    p_c_slot = int(attr.get('c_slot', 0))
                    hop_links.append({
                        'name': p_name,
                        'bitmap': TopologyHelper.int_to_bitmap(p_c_slot)
                    })
                    hop_intersection &= p_c_slot
                
                # Update the path-wide bitmap
                before_hop = current_bitmap
                current_bitmap &= hop_intersection
                
                trace_steps.append({
                    'hop_index': i + 1,
                    'hop_label': hop_label,
                    'parallel_links': hop_links,
                    'hop_bitmap': TopologyHelper.int_to_bitmap(hop_intersection),
                    'cumulative_bitmap': TopologyHelper.int_to_bitmap(current_bitmap)
                })
                
                logger.info(f"[RSA Pre-Compute] Hop {i+1} Result: {hop_intersection:b} | Cumulative: {current_bitmap:b}")
            else:
                logger.warning(f"[RSA Pre-Compute] Hop {i+1} ({u}->{v}): No edges found in graph!")

        return current_bitmap, total_slots, trace_steps

    @staticmethod
    def perform_rsa(path_obj, bandwidth, graph):
        """
        Performs Routing and Spectrum Assignment (RSA) for a given path and bandwidth.
        Considers parallel link constraints.
        """
        if not bandwidth:
            return None
            
        FLEX_GRID = 12.5
        num_slots = math.ceil(float(bandwidth) / FLEX_GRID)
        logger.info(f"[RSA] Starting RSA for bandwidth {bandwidth}Gbps. Required slots: {num_slots} (Bitmap: {'1' * int(num_slots)})")
        
        if not path_obj['links']:
            logger.warning("[RSA] Path has no links!")
            return None

        # --- Step 1: Pre-compute strict availability (considering parallel links) ---
        strict_bitmap, TOTAL_SLOTS, trace_steps = TopologyHelper.rsa_bitmap_pre_compute(path_obj, graph)
        
        # --- Step 2: Find Contiguous Slots (First Fit from LSB) using STRICT bitmap ---
        start_bit = -1
        current_run = 0
        
        # Iterate from bit 0 (LSB) to TOTAL_SLOTS
        for i in range(TOTAL_SLOTS):
            # Check if bit i is set (1)
            is_free = (strict_bitmap >> i) & 1
            
            if is_free:
                current_run += 1
                if current_run == num_slots:
                    # Found a run ending at i
                    # It started at i - num_slots + 1
                    start_bit = i - num_slots + 1
                    logger.info(f"[RSA] Found {num_slots} contiguous slots starting at bit {start_bit} (LSB)")
                    break
            else:
                current_run = 0
                
        if start_bit != -1:
            # Found slots!
            
            # Create "Required Slots" bitmap (N of 1s at the correct position)
            # Shift 1s to the start_bit position
            mask = ((1 << num_slots) - 1) << start_bit
            
            # Create Final Bitmap (Final Available Bitmap with slots taken -> 0)
            final_bitmap_val = strict_bitmap & ~mask
            
            # Format as strings (dynamic length)
            common_bitmap_str = f"{strict_bitmap:0{TOTAL_SLOTS}b}" # Show the strict intersection as "Result Bitmap"
            required_slots_str = f"{mask:0{TOTAL_SLOTS}b}"
            final_bitmap_str = f"{final_bitmap_val:0{TOTAL_SLOTS}b}"
            
            logger.info(f"[RSA] Success! Final Bitmap: {final_bitmap_str}")
            
            return {
                'success': True,
                'num_slots': num_slots,
                'num_slots_ones': '1' * int(num_slots),
                'common_bitmap': common_bitmap_str,
                'required_slots': required_slots_str,
                'final_bitmap': final_bitmap_str,
                'trace_steps': trace_steps,
                'mask': mask
            }
        else:
            logger.warning(f"[RSA] Failed. No contiguous slots found.")
            return {
                'success': False,
                'num_slots': num_slots,
                'common_bitmap': f"{strict_bitmap:0{TOTAL_SLOTS}b}",
                'error': "No contiguous slots found",
                'trace_steps': trace_steps,
                'mask': 0
            }

    @staticmethod
    def commit_slots(link_ids, mask):
        """
        Updates c_slot values for specific links and their endpoints in the path.
        """
        from models import db, OpticalLink, Endpoint
        
        if not link_ids or mask is None:
            logger.warning("[RSA Commit] Missing link_ids or mask, skipping update.")
            return False
            
        try:
            logger.info(f"[RSA Commit] Reserving mask {mask:b} for link_ids: {link_ids}")
            
            # 1. Fetch specific links by ID
            links = OpticalLink.query.filter(OpticalLink.id.in_(link_ids)).all()
            if not links:
                logger.error("[RSA Commit] No links found in database!")
                return False
                
            updated_endpoints = set()
            
            for link in links:
                # Update Link
                # Numeric fields (c_slot) come as Decimal, cast to int for bitwise ops and formatting
                current_val = int(link.c_slot)
                new_val = current_val & ~mask
                
                logger.info(f"  Updating Link {link.name}: {current_val:b} -> {new_val:b}")
                link.c_slot = new_val
                
                # Determine new status
                # First, check the consolidated OTN type using the same logic as process_optical_links
                src_otn = link.src_endpoint.otn_type
                dst_otn = link.dst_endpoint.otn_type
                consolidated_otn = src_otn if src_otn == dst_otn else "MISMATCH"
                
                if consolidated_otn == "OCH":
                    link.status = 'USED' # OCH is binary (FREE/USED)
                elif consolidated_otn == "OMS":
                    # OMS is three-state (FREE/USED/FULL)
                    # It's FULL only if both bands are 0
                    if int(link.c_slot) == 0 and int(link.l_slot) == 0:
                        link.status = 'FULL'
                    else:
                        link.status = 'USED'
                else:
                    link.status = 'USED' # Fallback
                
                # Update Endpoints (Endpoints only track in_use, not slots)
                for ep in [link.src_endpoint, link.dst_endpoint]:
                    if ep and ep.id not in updated_endpoints:
                        logger.info(f"    Marking Endpoint {ep.name} as in_use")
                        ep.in_use = True
                        updated_endpoints.add(ep.id)
            
            db.session.commit()
            logger.info("[RSA Commit] Database updated successfully.")
            return True
            
        except Exception as e:
            db.session.rollback()
            logger.error(f"[RSA Commit] Failed to update database: {str(e)}")
            return False

    @staticmethod
    def process_optical_links(links):
        """
        Processes optical links to determine the OTN type by comparing source and destination endpoints.
        Returns a list of dictionaries with link data and consolidated otn_type.
        """
        processed_links = []
        MAX_BIT_VALUE = 34359738367 # (2^35 - 1)

        for link in links:
            src_ep = link.src_endpoint
            dst_ep = link.dst_endpoint
            src_otn = src_ep.otn_type
            dst_otn = dst_ep.otn_type
            
            # 1. Determine consolidated OTN Type
            if src_otn == dst_otn:
                consolidated_otn = src_otn
            else:
                consolidated_otn = OTN_TYPE_MISMATCH
            
            # 2. Advanced Status Logic
            final_status = "UNKNOWN"
            
            if consolidated_otn == OTN_TYPE_MISMATCH:
                final_status = OTN_TYPE_MISMATCH
            
            elif consolidated_otn == OTN_TYPE_OCH:
                # OCH: Binary Logic (FREE/USED)
                if not src_ep.in_use and not dst_ep.in_use:
                    final_status = "FREE"
                else:
                    final_status = "USED"
            
            elif consolidated_otn == OTN_TYPE_OMS:
                # OMS: Three-state Logic (FREE/USED/FULL)
                any_in_use = src_ep.in_use or dst_ep.in_use
                all_slots_free = (int(link.c_slot) == MAX_BIT_VALUE and int(link.l_slot) == MAX_BIT_VALUE)
                all_slots_full = (int(link.c_slot) == 0 and int(link.l_slot) == 0)
                
                if not any_in_use and all_slots_free:
                    final_status = "FREE"
                elif any_in_use and all_slots_full:
                    final_status = "FULL"
                else:
                    final_status = "USED"

            # 3. Build Processed Dictionary
            processed_links.append({
                'id': link.id,
                'name': link.name,
                'src_device': link.src_device,
                'src_endpoint': src_ep,
                'dst_device': link.dst_device,
                'dst_endpoint': dst_ep,
                'status': final_status,
                'c_slot': link.c_slot,
                'l_slot': link.l_slot,
                'c_slot_bitmap': TopologyHelper.int_to_bitmap(link.c_slot),
                'l_slot_bitmap': TopologyHelper.int_to_bitmap(link.l_slot),
                'otn_type': consolidated_otn
            })
        return processed_links
