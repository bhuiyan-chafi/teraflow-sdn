from datetime import datetime
import json
from pathlib import Path
from lxml import etree
import xmltodict
from InitiateConnectionSSH import InitiateConnectionSSH
from loguru import logger

ROOT = Path(__file__).resolve().parents[1]
FILTER = (ROOT/"filters"/"openroadm-interfaces.xml").read_text()
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
        (OUT/f"{ts}_interfaces.xml").write_text(
            etree.tostring(etree.fromstring(
                xml), pretty_print=True, encoding="unicode")
        )
        data = xmltodict.parse(xml, process_namespaces=True, namespaces={
            "http://org/openroadm/device": "ord-dev",
            "http://org/openroadm/interfaces": "ord-if",
            "urn:ietf:params:xml:ns:netconf:base:1.0": "nc",
        })
        (OUT/f"{ts}_interfaces.json").write_text(json.dumps(data, indent=2))
        logger.success("Filtered device-interfaces saved.")
    finally:
        client.disconnect()
        logger.info("Disconnected from the device.")
    logger.success("Interfaces are filtered and saved in ./filters/outputs")


if __name__ == "__main__":
    try:
        main()
    except Exception as e:
        logger.error(f"Error: {e}")
        exit(1)
