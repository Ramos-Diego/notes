# Networks

| IP Address Class | Total # Of Bits For Network ID / Host ID | Default Subnet Mask |   First Octet  |  Second Octet  |   Third Octet  | Fourth Octet |
|:----------------:|:----------------------------------------:|:-------------------:|:--------------:|:--------------:|:--------------:|:------------:|
|      Class A     |                  8 / 24                  |      255.0.0.0      | 11111111  |  00000000   |  00000000   | 00000000  |
|      Class B     |                  16 / 16                 |     255.255.0.0     | 11111111  | 11111111  |  00000000   | 00000000  |
|      Class C     |                  24 / 8                  |    255.255.255.0    | 11111111  | 11111111  | 11111111  | 00000000  |

- TCP/IP

BINARY OCTECT

`128 64 32 16  8 4 2 1`

`0 0 1 1  1 1 1 1` = 63

The sum of ones from the right equals the next 0 in decimal - 1.

The IP address, Network ID and Subnet Mask are made of four binary octects (32 bits).


- Subenetwork

A subnetwork or subnet is a logical subdivision of an IP network. The practice of dividing a network into two or more networks is called subnetting.

Computers that belong to a subnet are addressed with an identical most-significant bit-group in their IP addresses. This results in the logical division of an IP address into two fields, the network number or routing prefix and the rest field or host identifier. The rest field is an identifier for a specific host or network interface.

The routing prefix may be expressed in Classless Inter-Domain Routing (CIDR) notation written as the first address of a network, followed by a slash character (/), and ending with the bit-length of the prefix. For example, 198.51.100.0/24 is the prefix of the Internet Protocol version 4 network starting at the given address, having 24 bits allocated for the network prefix, and the remaining 8 bits reserved for host addressing. Addresses in the range 198.51.100.0 to 198.51.100.255 belong to this network.

For IPv4, a network may also be characterized by its subnet mask or netmask, which is the bitmask that when applied by a bitwise AND operation to any IP address in the network, yields the routing prefix. Subnet masks are also expressed in dot-decimal notation like an address. For example, 255.255.255.0 is the subnet mask for the prefix 198.51.100.0/24.

Traffic is exchanged between subnetworks through routers when the routing prefixes of the source address and the destination address differ. A router serves as a logical or physical boundary between the subnets.

- Network ID

Network identity (network ID) is a portion of the TCP/IP address that is used to identify individuals or devices on a network such as a local area network or the Internet. Network ID is designed to ensure the security of a network and related resources.

- Classless Inter-Domain Routing (CIDR) is a method for allocating IP addresses and for IP routing.