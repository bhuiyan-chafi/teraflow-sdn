import re

# Read the devices.sql to get the list of RDM names
with open('sql/paneu_topo/devices.sql', 'r') as f:
    content = f.read()

devices = re.findall(r"'RDM[a-z]+'", content)
devices = [d.strip("'") for d in set(devices)]

bitmap_value = '10520271803096747014481979765760257331100679605646347718996561806137464308594161644227333072555176902453965937712356435426038864500367607726255629541303761699910447342256889196383327515768645434542586503471562751'

with open('sql/paneu_topo/device_endpoints.sql', 'w') as f:
    f.write("-- Pan-EU Topology Device Endpoints\n")
    f.write("-- Each RDM has exactly 12 OMS endpoints (2001-2012). No OCH endpoints are needed.\n\n")

    for device in devices:
        f.write(f"-- {device} (OMS endpoints)\n")
        f.write("INSERT INTO endpoints (id, device_id, name, type, otn_type, in_use, min_frequency, max_frequency, flex_slots, bitmap_value, status, created_at, updated_at) VALUES\n")
        
        for i in range(1, 13):
            port_name = f"20{i:02d}"
            line = f"(gen_random_uuid(), (SELECT id FROM devices WHERE name='{device}'), '{port_name}', 'duplex', 'OMS', false, 191556250000000, 195937500000000, 701, '{bitmap_value}', 'FREE', NOW(), NOW())"
            if i == 12:
                f.write(line + ";\n\n")
            else:
                f.write(line + ",\n")

print(f"Generated endpoints for {len(devices)} devices.")
