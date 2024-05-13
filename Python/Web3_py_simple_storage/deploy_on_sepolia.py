import json
import os
from solcx import compile_standard, install_solc
from web3 import Web3
from dotenv import load_dotenv

"""
To load sensitive variables such as passwords that you don't want expose, use .env files
and use the 'load_dotenv()' function to import those variables into your program. Remember
though to add the '.env' file to a '.gitignore' file if you intend to export it to git
"""
load_dotenv()

install_solc(
    "0.8.0"
)  # PNB: this should match the pragma solidity version in 'SimpleStorage.sol' in order for compilation to work

with open("./SimpleStorage.sol", "r") as file:
    simple_storage_file = file.read()
    # print(simple_storage_file)

# ----------------------------------------
# C1. Compiling our Solidity
# ----------------------------------------

compiled_sol = compile_standard(
    {
        "language": "Solidity",
        "sources": {"SimpleStorage.sol": {"content": simple_storage_file}},
        "settings": {
            "outputSelection": {
                "*": {"*": ["abi", "metadata", "evm.bytecode", "evm.sourceMap"]}
            }
        },
    },
    solc_version="0.8.0",  # this version should match the version given to 'install_solc()' function above
)  # for compiling the solidity code

# ----------------------------------------
# C2. Writing out the compiled code to a file
# ----------------------------------------

# print(compiled_sol)
with open("compiled_code.json", "w") as file:
    json.dump(
        compiled_sol, file
    )  # The reason why outputting to json fomat is import: the information on the ABI is very important during development

# ----------------------------------------
# C3. DEPLOYING: What is needed? => The 1. bytecode 2. the abi
# ----------------------------------------

## get the bytecode
bytecode = compiled_sol["contracts"]["SimpleStorage.sol"]["SimpleStorage"]["evm"][
    "bytecode"
]["object"]

## get the abi
abi = compiled_sol["contracts"]["SimpleStorage.sol"]["SimpleStorage"][
    "abi"
]  # PNB: sometimes people have a separate ABI file (say 'abi.json') where they will place abis instead of getting it from a general json file as done here

## PNB: node URL or link; Remote Procedure Call (RPC)
sepolia_RPC_ENDPOINT = "https://sepolia.infura.io/v3/318c2edb27004a5782f068547cbd370e"# PNB: Using the endpoint link for sepolia testnet given by my free account on infura.io

## private VM connection (connecting to Ganache)
# IPCProvider:

w3 = Web3(Web3.IPCProvider("./path/to/geth.ipc"))
w3_link = Web3(
    Web3.HTTPProvider(sepolia_RPC_ENDPOINT)
)  # the http link corresponds to the endpoint link given by online EVM (sepolia in this case); as informed by  infura
chain_id = 11155111 # PNB: you can check the chain_id from 'chainid.network' and 'coincap.com'
my_address = "0x13cCB09348f46cF194f59Ea505fd747D3ABd737b"  # PNB: grab my address from my metamask wallet that I intend to use

# private_key = "0x71158d343dee338c503ceedd1aa5b44b25254604224b446f4ba801323a4da1f1"  # a. Hardcoding method: Warning: bad to keep private key in source code here.
# private_key = os.getenv("PRIVATE_KEY")# b. Environmental variable method: A more secure (but not fully effected) approach
# print(private_key)

# b. Using '.env' file method: make sure to add '.env' file to .gitignore file
private_key = os.getenv("PRIVATE_KEY") #PNB: grab my private key for your wallet; from your metamask
print(private_key)

## PNB: Check to see if connection worked
print(w3_link.is_connected())
# Verify if the connection is successful
if w3_link.is_connected():
    print("-" * 50)
    print("Connection Successful")
    print("-" * 50)
else:
    print("Connection Failed")

# ----------------------------------------
# C4. Create the contract now in python
# ----------------------------------------
SimpleStorage = w3_link.eth.contract(abi=abi, bytecode=bytecode)
# print("-"*50,"\n","SimpleStorage:\n","-"*50,"\n",SimpleStorage)

# ----------------------------------------
# C5. We can actually get our 'nonce' by attempting to get the latest transaction
# ----------------------------------------
nonce = w3_link.eth.get_transaction_count(my_address)
print(
    "nonce:", nonce
)  # nonce should be equal to zero here because I a transaction has not yet been effected

# -------------------------------------------------------------
# C6. PNB: Get a transaction through (DEPLOYING A TRANSACTION)
# -------------------------------------------------------------
""" 
Regardless of whether one is deploying a transaction (CONTRACT CREATION) or 
Making a transaction (CONTRACT CALL) after having already deployed a tranaction,
one has to go through these three steps
1. Build a transaction
2. Sign a transaction
3. Send a transaction
"""

## --- DEPLOYING A TRANSACTION ---

### Building transaction
transaction = SimpleStorage.constructor().build_transaction(
    {"chainId": chain_id, "from": my_address, "nonce": nonce}
)
# print("-"*50,"\n","Transaction variable => transaction:\n","-"*50,"\n",transaction)

### Signing transaction
signed_txn = w3_link.eth.account.sign_transaction(transaction, private_key=private_key)
# print("-" * 50, "\n", "Signed Transaction variable => signed_txn:\n", "-" * 50, "\n", signed_txn)

### Send the signed transaction to the blockchain
print("\n")
print("Deploying contract...")
tx_hash = w3_link.eth.send_raw_transaction(signed_txn.rawTransaction)
tx_receipt = w3_link.eth.wait_for_transaction_receipt(
    tx_hash
)  # Wait for transaction to finish; recommended good practice
print("Contract deployed!")

# ----------------------------------------
# C7. Working with a contract after getting it through
# ----------------------------------------
"""
This needed: 1. Contract Address 2. Contract ABI
"""
simple_storage = w3_link.eth.contract(address=tx_receipt.contractAddress, abi=abi)


# ---------------------------------------------------------------------------------------------------------
# C8. Now that we have the address and ABI, we can start interracting with our ABI like we did with REMIX
# ---------------------------------------------------------------------------------------------------------
"""
Two types of transactional interractions with a blockchain:
1. Call => Simulated call; no state change on the blockchain; similar to view functions as seen - colored denoted - in the blue color in solidity
2. Transaction => Actual call made; actual state change on the blockchain even if it's a view function; similar to non-view functions as seen - colored denoted -  in the red color in solidity
"""
## Example of calls made to abi
print(
    "function retrieveView() call (initial):",
    simple_storage.functions.retrieveView().call(),
)
# print(simple_storage.functions.store(15).call)

## --- MAKING A TRANSACTION ---

### Build transaction
print("\n")
print("Updating contract...")
store_transaction = simple_storage.functions.store(15).build_transaction(
    {
        "chainId": chain_id,
        "from": my_address,
        "nonce": nonce
        + 1,  # nonce + 1 because nouce and be used only once so you have to increase the previous nonce
    }
)

### Sign transaction
signed_stored_txn = w3_link.eth.account.sign_transaction(
    store_transaction, private_key=private_key
)

### Send a transaction
send_store_txn = w3_link.eth.send_raw_transaction(signed_stored_txn.rawTransaction)
tx_receipt = w3_link.eth.wait_for_transaction_receipt(send_store_txn)
print("Contract updated!")
print(
    "function retrieveView() call (updated):",
    simple_storage.functions.retrieveView().call(),
)
