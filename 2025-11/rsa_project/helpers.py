import logging
import math
import networkx as nx

# Configure logging
logger = logging.getLogger(__name__)

class TopologyHelper:
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
                    'src': u,
                    'dst': v,
                    'src_port': out_port,
                    'dst_port': in_port,
                    'name': attr['name'],
                    'status': attr['status'],
                    'c_slot': attr['c_slot'] # Include c_slot for RSA
                })
                
                backtrack(index + 1, current_edge_path)
                current_edge_path.pop()

        backtrack(0, [])
        return valid_edge_paths

    @staticmethod
    def rsa_bitmap_pre_compute(path_obj, graph):
        """
        Computes the available spectrum bitmap by intersecting with ALL parallel links
        for each hop in the path.
        """
        if not path_obj['links']:
            return 0, 0
            
        # Initialize with the first link's c_slot
        first_link = path_obj['links'][0]
        current_bitmap = int(first_link['c_slot'])
        total_slots = current_bitmap.bit_length()
        
        logger.info(f"[RSA Pre-Compute] Initial Bitmap from {first_link['name']}: {current_bitmap:b} (Length: {total_slots})")
        
        # Iterate through each hop in the path
        for i, link in enumerate(path_obj['links']):
            u, v = link['src'], link['dst']
            
            # Find all parallel edges between u and v
            # graph is a MultiGraph, so graph[u][v] returns a dict of edges
            if graph.has_edge(u, v):
                parallel_edges = graph[u][v]
                logger.info(f"[RSA Pre-Compute] Hop {i+1} ({u}->{v}): Found {len(parallel_edges)} parallel links.")
                
                for key, attr in parallel_edges.items():
                    p_name = attr.get('name', 'unknown')
                    p_c_slot = int(attr.get('c_slot', 0))
                    
                    # Intersect
                    before = current_bitmap
                    current_bitmap &= p_c_slot
                    logger.info(f"[RSA Pre-Compute]   Intersecting with {p_name}: {p_c_slot:b} -> Result: {current_bitmap:b}")
            else:
                logger.warning(f"[RSA Pre-Compute] Hop {i+1} ({u}->{v}): No edges found in graph!")

        logger.info(f"[RSA Pre-Compute] Final Strict Bitmap: {current_bitmap:b}")
        return current_bitmap, total_slots

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
        strict_bitmap, TOTAL_SLOTS = TopologyHelper.rsa_bitmap_pre_compute(path_obj, graph)
        
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
            
            # --- Step 3: Calculate Display Bitmaps ---
            # User requested: "bring the initial bitmap again(from the first hop)"
            # and "reserve the required slots" from THAT bitmap.
            
            first_link = path_obj['links'][0]
            initial_path_bitmap = int(first_link['c_slot'])
            
            # Create Final Bitmap (Initial Path Bitmap with slots taken -> 0)
            final_bitmap_val = initial_path_bitmap & ~mask
            
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
                'final_bitmap': final_bitmap_str
            }
        else:
            logger.warning(f"[RSA] Failed. No contiguous slots found.")
            return {
                'success': False,
                'num_slots': num_slots,
                'common_bitmap': f"{strict_bitmap:0{TOTAL_SLOTS}b}",
                'error': "No contiguous slots found"
            }
