import asyncio
import logging
import json
import os
from pymodbus.server.async_io import StartTcpServer
from pymodbus.datastore import ModbusServerContext, ModbusSlaveContext, ModbusSequentialDataBlock
from pymodbus.device import ModbusDeviceIdentification
from pymodbus.transaction import ModbusRtuFramer, ModbusBinaryFramer
from pymodbus.server.async_io import ModbusTcpServer

from web3 import Web3

# Enable detailed logging
logging.basicConfig()
log = logging.getLogger()
log.setLevel(logging.INFO)

# --------------------------- Blockchain Setup ---------------------------

GANACHE_URL = "http://127.0.0.1:7545"  # Ganache RPC
CONTRACT_ADDRESS = "PUT_YOUR_CONTRACT_ADDRESS_HERE"

with open("abi.json", "r") as f:
    contract_abi = json.load(f)

web3 = Web3(Web3.HTTPProvider(GANACHE_URL))

if web3.is_connected():
    print("[+] Connected to Ganache")
else:
    print("[-] Failed to connect to Ganache")
    exit()

contract = web3.eth.contract(address=CONTRACT_ADDRESS, abi=contract_abi)
account = web3.eth.accounts[0]

def log_to_blockchain(alert_msg):
    print(f"[*] Logging alert to blockchain: {alert_msg}")
    tx_hash = contract.functions.logAlert(alert_msg).transact({'from': account})
    receipt = web3.eth.wait_for_transaction_receipt(tx_hash)
    print("[+] Alert written to blockchain successfully.")

# --------------------------- Modbus Setup ---------------------------

store = ModbusSlaveContext(
    di=ModbusSequentialDataBlock(0, [0]*100),
    co=ModbusSequentialDataBlock(0, [0]*100),
    hr=ModbusSequentialDataBlock(0, [0]*100),
    ir=ModbusSequentialDataBlock(0, [0]*100)
)
context = ModbusServerContext(slaves={0x01: store}, single=True)

# --------------------------- Custom Handler ---------------------------

async def custom_request_handler(request):
    peer_info = request.transport.get_extra_info('peername')
    if not peer_info:
        return
    client_ip, _ = peer_info
    function_code = request.function_code

    # DEBUG Print for all requests
    print(f"[DEBUG] Received request from {client_ip} | Function Code: {function_code}")

    # Detect and log unauthorized coil write
    if function_code == 5:
        alert_msg = f"Unauthorized coil write detected from {client_ip}"
        log_to_blockchain(alert_msg)

        # OPTIONAL: Block IP (this assumes you have pfSense firewall API or CLI command available)
        # os.system(f"pfctl -t blocked_ips -T add {client_ip}")
        print(f"[!] Unauthorized coil write blocked and logged for {client_ip}")

# --------------------------- Run Server ---------------------------

async def run_server():
    print("[*] Starting combined IDS + Blockchain logger...")

    server = ModbusTcpServer(
        context, 
        address=("0.0.0.0", 502),
        custom_functions=[custom_request_handler]  # attach custom handler
    )

    await server.serve_forever()

if __name__ == "__main__":
    asyncio.run(run_server())

