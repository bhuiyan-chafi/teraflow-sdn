import urllib.request
import re

url = "http://sndlib.zib.de/home.action"
print("checking sndlib")

try:
    req = urllib.request.urlopen("http://sndlib.zib.de/download/networks/nobel-eu.xml")
    xml_data = req.read().decode('utf-8')
    print("Found nobel-eu.xml!")
    
    # Extract nodes
    nodes = re.findall(r'<node id="(.*?)">', xml_data)
    print("Nodes:", len(nodes), nodes)
    
    # Extract links
    links = re.findall(r'<link id=".*?">\s*<source>(.*?)</source>\s*<target>(.*?)</target>', xml_data, re.DOTALL)
    print("Links:", len(links))
    for link in links:
        print(link)
except Exception as e:
    print("Error:", e)
