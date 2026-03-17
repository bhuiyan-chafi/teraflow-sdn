# Port Configuration of Emulated Devices

Let me give you the new port configuration of transponders and roadms.

## A transponder is configured with:

port-1 to port-4 total 4 ports where 1,2,3,4 is the index and TP1_1 becomes the index for port-1 which has been used in the links.

## For ROADM devices:

RDM1_4101 is the index where 4101 is the port name like transponder's port-1.

**_Important:_** the most important part is that for a link we have to make sure an OCH port is connected to another OCH port between two devices. All the ports of transponder are OCH ports but for roadm OCH ports are 4101,4102,4201 and 5101. Remember that 5101 is always used for peer connection and we will never use it except that. A connection between two roadm can be established using two OMS ports only which are ports 5201,5202, 5203, 5204 and 4103, 4104.
