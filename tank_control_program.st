from web3 import Web3
from datetime import datetime

# Connect to Ganache
ganache_url = "http://127.0.0.1:7545"
web3 = Web3(Web3.HTTPProvider(ganache_url))

# Check connection
if not web3.isConnected():
    print("❌ Failed to connect to Ganache")
    exit()

# Use first Ganache account
sender_address = web3.eth.accounts[0]
private_key = "0x4f3edf983ac636a65a842ce7c78d9aa706d3b113b37d97ef5cfb5e3c4d7d20ee"  # ← Replace if using another account

# Prepare transaction function
def log_to_blockchain(message):
    try:
        # Create transaction
        nonce = web3.eth.get_transaction_count(sender_address)
        txn = {
            'nonce': nonce,
            'to': sender_address,
            'value': 0,
            'gas': 200000,
            'gasPrice': web3.to_wei('1', 'gwei'),
            'data': web3.to_hex(text=f"[{datetime.now()}] {message}")
        }

        # Sign and send
        signed_txn = web3.eth.account.sign_transaction(txn, private_key)
        tx_hash = web3.eth.send_raw_transaction(signed_txn.rawTransaction)
        print(f"[✓] Alert logged to blockchain. Txn hash: {web3.to_hex(tx_hash)}")

    except Exception as e:
        print(f"⚠️ Logging failed: {e}")
