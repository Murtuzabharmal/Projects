import asyncio
import logging
import json
from pymodbus.server.async_io import StartTcpServer
from pymodbus.datastore import ModbusSlaveContext, ModbusSequentialDataBlock, ModbusServerContext
from pymodbus.device import ModbusDeviceIdentification
from pymodbus.transaction import ModbusRtuFramer, ModbusBinaryFramer
from pymodbus.server.async_io import ModbusTcpServer
from pymodbus.datastore.context import ModbusContext
from pymodbus.pdu import ModbusRequest
from pymodbus.server.async_io import ModbusConnectedRequestHandler

from web3 import Web3

# Enable logging
logging.basicConfig()
log = logging.getLogger()
log.setLevel(logging.INFO)

# -------------------- Blockchain Setup --------------------

GANACHE_URL = "http://127.0.0.1:7545"
CONTRACT_ADDRESS = "PUT_YOUR_CONTRACT_ADDRESS_HERE"  # <- Replace this

with open("abi.json", "r") as f:
    contract_abi = json.load(f)

web3 = Web3(Web3.HTTPProvider(GANACHE_URL))

if web3.isConnected():
    print("[+] Connected to Ganache")
else:
    print("[-] Failed to connect to Ganache")
    exit()

contract = web3.eth.contract(address=CONTRACT_ADDRESS, abi=contract_abi)
account = web3.eth.accounts[0]

def log_to_blockchain(alert_msg):
    print(f"[!] Logging to blockchain: {alert_msg}")
    tx_hash = contract.functions.logAlert(alert_msg).transact({'from': account})
    receipt = web3.eth.wait_for_transaction_receipt(tx_hash)
    print("[+] Logged on-chain.")

# -------------------- Modbus Setup --------------------

store = ModbusSlaveContext(
    di=ModbusSequentialDataBlock(0, [0]*100),
    co=ModbusSequentialDataBlock(0, [0]*100),
    hr=ModbusSequentialDataBlock(0, [0]*100),
    ir=ModbusSequentialDataBlock(0, [0]*100)
)
context = ModbusServerContext(slaves={0x01: store}, single=True)

# -------------------- Custom Request Handler --------------------

class CustomHandler(ModbusConnectedRequestHandler):
    async def handle(self):
        peer_ip = self.request.get_extra_info("peername")[0]
        while True:
            try:
                request = await self.receive()
                if request is None:
                    break

                # Log and detect coil write (FC=5)
                if request.function_code == 5:
                    alert = f"Unauthorized coil write detected from {peer_ip}"
                    log_to_blockchain(alert)

                response = await self.server.decoder.decode(request)
                await self.send(response)

            except Exception as e:
                print(f"[!] Handler error: {e}")
                break

# -------------------- Run Server --------------------

async def main():
    print("[*] Starting Modbus IDS + Blockchain Logger on port 502...")
    await StartTcpServer(
        context,
        address=("0.0.0.0", 502),
        handler=CustomHandler
    )

if __name__ == "__main__":
    asyncio.run(main())



#Another code for decode the content
from web3 import Web3

# Connect to Ganache
ganache_url = "http://127.0.0.1:7545"
web3 = Web3(Web3.HTTPProvider(ganache_url))

if web3.is_connected():
    print("[+] Connected to Ganache")
else:
    print("[-] Failed to connect to Ganache")
    exit()

# Replace with your actual transaction hash
tx_hash = "PUT_YOUR_TX_HASH_HERE"

# Get transaction receipt
tx_receipt = web3.eth.get_transaction_receipt(tx_hash)
print(tx_receipt)

