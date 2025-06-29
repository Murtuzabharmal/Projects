import asyncio
import logging

from pymodbus.server.async_io import ModbusTcpServer
from pymodbus.datastore import (
    ModbusServerContext,
    ModbusSlaveContext,
    ModbusSequentialDataBlock
)

# Setup logging
logging.basicConfig()
log = logging.getLogger()
log.setLevel(logging.INFO)

# Setup Modbus datastore
store = ModbusSlaveContext(
    di=ModbusSequentialDataBlock(0, [0]*100),
    co=ModbusSequentialDataBlock(0, [0]*100),
    hr=ModbusSequentialDataBlock(0, [0]*100),
    ir=ModbusSequentialDataBlock(0, [0]*100)
)

context = ModbusServerContext(slaves={0x01: store}, single=True)

async def main():
    print("✅ Modbus TCP server (pymodbus 3.6.9) is running on port 5020...")
    server = ModbusTcpServer(context, address=("0.0.0.0", 5020))
    await server.serve_forever()

if __name__ == "__main__":
    asyncio.run(main())

# Syslog code for Pfsense
import logging
import logging.handlers
from scapy.all import sniff, IP, TCP, Raw

# === SYSLOG CONFIGURATION ===
SYSLOG_SERVER = '192.168.76.1'  # Your pfSense IP
SYSLOG_PORT = 514

logger = logging.getLogger()
logger.setLevel(logging.INFO)
syslog_handler = logging.handlers.SysLogHandler(address=(SYSLOG_SERVER, SYSLOG_PORT), socktype=socket.SOCK_DGRAM)
formatter = logging.Formatter('%(asctime)s IDS_ALERT: %(message)s')
syslog_handler.setFormatter(formatter)
logger.addHandler(syslog_handler)

def detect_modbus_write(packet):
    if packet.haslayer(TCP) and packet.haslayer(Raw):
        payload = packet[Raw].load
        if packet[TCP].dport == 502 and len(payload) > 7 and payload[7] == 0x05:
            attacker_ip = packet[IP].src
            alert = f"Unauthorized Coil Write from {attacker_ip}"
            print(f"[!] {alert}")
            logger.info(alert)

print("[*] IDS Started: Watching for coil writes...")
sniff(filter="tcp port 502", prn=detect_modbus_write, store=0)

