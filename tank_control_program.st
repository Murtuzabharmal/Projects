from web3 import Web3

# Ganache local blockchain URL
ganache_url = "http://127.0.0.1:7545"
web3 = Web3(Web3.HTTPProvider(ganache_url))

# Check if connected
print("[*] Connecting to Ganache...")
if not web3.is_connected():
    print("[-] Failed to connect to Ganache.")
    exit()
print("[+] Connected to Ganache")

# Use first account provided by Ganache
account = web3.eth.accounts[0]

# Smart contract ABI (copied from Remix after compilation)
abi = [
    {
        "anonymous": False,
        "inputs": [{"indexed": False, "internalType": "string", "name": "message", "type": "string"}],
        "name": "AlertLogged",
        "type": "event"
    },
    {
        "inputs": [{"internalType": "string", "name": "message", "type": "string"}],
        "name": "logAlert",
        "outputs": [],
        "stateMutability": "nonpayable",
        "type": "function"
    }
]

# Smart contract address (update with deployed contract address)
contract_address = "0xYourContractAddressHere"  # <- paste from Remix

# Load contract
contract = web3.eth.contract(address=contract_address, abi=abi)

# Create and send transaction
message = "Unauthorized coil write detected from 192.168.76.12"
print(f"[*] Logging alert to blockchain: {message}")
tx_hash = contract.functions.logAlert(message).transact({'from': account})
web3.eth.wait_for_transaction_receipt(tx_hash)
print("[+] Alert written to blockchain successfully.")


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


