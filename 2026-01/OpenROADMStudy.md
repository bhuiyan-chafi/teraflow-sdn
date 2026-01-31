# A simple Study

According to the PDF that professor alessio gave me, says that the DEG external ports should be defined as AMP(amplifiers). But in the nodeTIM.xml we saw that, two circuit packs are present there then both SRG and DEG is sharing ports from that. So, I assume that all physical hardware resides in the same category where they are assigned logically through the configuration.

## SRGs(Shared Risk Group)

An SRG contains both PP(physical-port) and wss(wavelength-select-switch) ports. The WSS ports of the SRGs are connected to the WSS ports of the DEGs. These are internal connections(physically wired) that we are not interested for now. But a probable contribution for teraflow would be, CLI/REST/gRPC based port cross connection like ONOS.

## DEGs(Degrees)

While in the DEGs we have WSS(switching) and AMP(don't drop or add just send) ports. Right now the way we are operating in both ONOS and TeraFlow is that we are not considering if a port is WSS or AMP. We are considering them as input and output ports, maybe in future if we work with real devices we have to separate them logically.

Another interesting fact in the DEG ports is that, there are two logical separations of the ports. These are:

- ***OTS(Optical Transport Section)***: This is the logical representation of the physical fiber itself. What type of fiber, what is the capacity, loss, length and operation of the physical amplifier is defined here.
- ***OMS(Optical Multiplex Section)***: This is the logical representation of the wavelengths that are traveling together through that OTS. OMS seats on top of OTS, even in the xml you will see that the OMS has a connection via `<supporting-interface>OTS-DEG1-TX</supporting-interface>` to OTS.
