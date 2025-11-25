from datetime import datetime
import json
from pathlib import Path
from lxml import etree
import xmltodict
from InitiateConnectionSSH import InitiateConnectionSSH
from loguru import logger

# the root directory of the project
ROOT = Path(__file__).resolve().parents[1]
# the filter file to be used for retrieving device information
FILTER = (ROOT/"filters"/"openroadm-device.xml").read_text()
OUT = ROOT/"filters/outputs"
OUT.mkdir(exist_ok=True)
ts = datetime.utcnow().strftime("%Y%m%dT%H%M%SZ")

if not FILTER:
    raise FileNotFoundError(f"Missing filter file: {FILTER}")


def main() -> None:
    client = InitiateConnectionSSH()
    try:
        connection_instance = client.connect()
        reply = connection_instance.get(filter=FILTER)
        xml = reply.data_xml.encode()
        # save the retrieved XML data to a file
        (OUT/f"{ts}_device.xml").write_text(
            etree.tostring(etree.fromstring(
                xml), pretty_print=True, encoding="unicode")
        )
        data = xmltodict.parse(xml, process_namespaces=True, namespaces={
            "http://org/openroadm/device": "ord-dev",
            "urn:ietf:params:xml:ns:netconf:base:1.0": "nc"
        })
        # save the parsed JSON data to a file
        (OUT/f"{ts}_device.json").write_text(json.dumps(data, indent=2))
        logger.success("Filtered device data saved.")
    finally:
        client.disconnect()
        logger.info("Disconnected from the device.")
    logger.success("Devices are filtered and saved in ./filters/outputs")


if __name__ == "__main__":
    try:
        main()
    except Exception as e:
        logger.error(f"Error: {e}")
        exit(1)
