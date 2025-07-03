
from scapy.all import sniff, IP, TCP, Raw

def detect_modbus_write(packet):
    if packet.haslayer(TCP) and packet.haslayer(Raw):
        payload = packet[Raw].load
        # Check if it's Modbus TCP (port 502) and function code is 0x05 (Write Single Coil)
        if packet[TCP].dport == 502 and len(payload) > 7 and payload[7] == 0x05:
            attacker_ip = packet[IP].src
            print(f"[!] ALERT: Coil Write Detected from IP: {attacker_ip}")

print("[*] Modbus IDS Started – Monitoring for unauthorized coil writes (Function Code 0x05)...")

sniff(filter="tcp port 502", prn=detect_modbus_write, store=0)


# other program
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract AlertLogger {
    string[] public alerts;

    event AlertLogged(string message); // 🔥 Add this line

    function logAlert(string memory _message) public {
        alerts.push(_message);
        emit AlertLogged(_message); // 🔥 Emit event
    }

    function getAlert(uint _index) public view returns (string memory) {
        return alerts[_index];
    }

    function getAlertCount() public view returns (uint) {
        return alerts.length;
    }
}
