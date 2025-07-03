import asyncio
import logging
from pymodbus.server.async_io import StartTcpServer
from pymodbus.datastore import ModbusSlaveContext, ModbusServerContext, ModbusSequentialDataBlock
from pymodbus.device import ModbusDeviceIdentification
from pymodbus.transaction import ModbusRtuFramer, ModbusBinaryFramer
from web3 import Web3
from datetime import datetime

# ----------------- Modbus Server Configuration -----------------
logging.basicConfig()
log = logging.getLogger()
log.setLevel(logging.INFO)

store = ModbusSlaveContext(
    di=ModbusSequentialDataBlock(0, [0]*100),
    co=ModbusSequentialDataBlock(0, [0]*100),
    hr=ModbusSequentialDataBlock(0, [0]*100),
    ir=ModbusSequentialDataBlock(0, [0]*100)
)
context = ModbusServerContext(slaves=store, single=True)

# ----------------- Blockchain Configuration -----------------
GANACHE_URL = "http://127.0.0.1:7545"
CONTRACT_ADDRESS = "<PUT_YOUR_CONTRACT_ADDRESS_HERE>"
PRIVATE_KEY = "<PUT_YOUR_PRIVATE_KEY_HERE>"
ACCOUNT_ADDRESS = "<PUT_YOUR_PUBLIC_ADDRESS_HERE>"

contract_abi = [
    {
        "inputs": [
            {
                "internalType": "string",
                "name": "alert",
                "type": "string"
            }
        ],
        "name": "logAlert",
        "outputs": [],
        "stateMutability": "nonpayable",
        "type": "function"
    }
]

web3 = Web3(Web3.HTTPProvider(GANACHE_URL))

if web3.isConnected():
    print("[+] Connected to Ganache")
else:
    print("[-] Failed to connect to Ganache")
    exit()

contract = web3.eth.contract(address=CONTRACT_ADDRESS, abi=contract_abi)

# ----------------- Custom Alert Logging -----------------
def check_for_attack(function_code, ip):
    if function_code == 5:  # Write Single Coil
        if ip != "192.168.76.100":
            return f"Unauthorized coil write detected from {ip}"
    return None

def log_to_blockchain(message):
    print(f"[*] Logging alert to blockchain: {message}")
    nonce = web3.eth.getTransactionCount(ACCOUNT_ADDRESS)
    txn = contract.functions.logAlert(message).buildTransaction({
        'chainId': 1337,
        'gas': 2000000,
        'gasPrice': web3.toWei('50', 'gwei'),
        'nonce': nonce
    })
    signed_txn = web3.eth.account.signTransaction(txn, private_key=PRIVATE_KEY)
    tx_hash = web3.eth.sendRawTransaction(signed_txn.rawTransaction)
    web3.eth.waitForTransactionReceipt(tx_hash)
    print("[+] Alert written to blockchain successfully.")

# ----------------- Async Modbus Server -----------------
async def start_modbus_server():
    print("[*] Starting combined IDS + Blockchain logger...")
    await StartTcpServer(context, address=("0.0.0.0", 5020))

if __name__ == "__main__":
    asyncio.run(start_modbus_server())
