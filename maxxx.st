from pymodbus.server.async_io import StartTcpServer
from pymodbus.datastore import ModbusSlaveContext, ModbusServerContext, ModbusSequentialDataBlock
from pymodbus.device import ModbusDeviceIdentification
from pymodbus.transaction import ModbusRtuFramer, ModbusBinaryFramer

from web3 import Web3
import logging

# --- Setup logging ---
logging.basicConfig()
log = logging.getLogger()
log.setLevel(logging.INFO)

# --- Blockchain connection ---
ganache_url = "http://127.0.0.1:7545"
web3 = Web3(Web3.HTTPProvider(ganache_url))

# Contract details (update with your actual contract info)
contract_address = Web3.to_checksum_address("0xYOUR_CONTRACT_ADDRESS_HERE")
with open("abi.json", "r") as f:
    abi = f.read()

contract = web3.eth.contract(address=contract_address, abi=abi)
account = web3.eth.accounts[0]

# --- Data Store for Modbus Server ---
store = ModbusSlaveContext(
    di=ModbusSequentialDataBlock(0, [0]*100),
    co=ModbusSequentialDataBlock(0, [0]*100),
    hr=ModbusSequentialDataBlock(0, [0]*100),
    ir=ModbusSequentialDataBlock(0, [0]*100)
)
context = ModbusServerContext(slaves=store, single=True)

# --- Custom request handler ---
def custom_coil_write(address, value, client_ip):
    if address == 0 and value == 1:
        alert_message = f"Unauthorized coil write detected from {client_ip}"
        print("[!] " + alert_message)
        # Write to blockchain
        tx_hash = contract.functions.logAlert(alert_message).transact({'from': account})
        receipt = web3.eth.wait_for_transaction_receipt(tx_hash)
        print("[+] Alert written to blockchain successfully.")

# --- Main server loop with hook ---
from pymodbus.server.async_io import ModbusTcpServer
import asyncio

class CustomModbusServer(ModbusTcpServer):
    async def handle(self, reader, writer):
        client_ip = writer.get_extra_info('peername')[0]
        while True:
            try:
                data = await reader.read(1024)
                if not data:
                    break
                if b'\x05' in data:  # Function code 5 = Write Single Coil
                    address = int.from_bytes(data[8:10], byteorder='big')
                    value = int.from_bytes(data[10:12], byteorder='big')
                    custom_coil_write(address, value, client_ip)
            except Exception as e:
                print(f"[!] Error: {e}")
                break

async def run_server():
    print("[*] Starting combined IDS + Blockchain logger...")
    server = CustomModbusServer(context, address=("0.0.0.0", 5020))
    await server.serve_forever()

if __name__ == "__main__":
    asyncio.run(run_server())
