from solcx import compile_standard, install_solc
import json
from web3 import Web3

install_solc("0.8.0") # PNB: this should match the pragma solidity version in 'SimpleStorage.sol' in order for compilation to work

with open("./SimpleStorage.sol", "r") as file:
    simple_storage_file = file.read()
    #print(simple_storage_file)

#C1. Compiling our Solidity
compile_sol = compile_standard(
    {
        "language": "Solidity",
        "sources": {"SimpleStorage.sol": {"content": simple_storage_file}},
        "settings": {
            "outputSelection": {
                "*": {"*": ["abi", "metadata", "evm.bytecode", "evm.sourceMap"]}
            }
        },
    },
    solc_version="0.8.0",# this version should match the version given to 'install_solc()' function above
)# for compiling the solidity code

#C2. Writing out the compiled code to a file
#print(compile_sol)
with open("compiled_code.json","w") as file:
    json.dump(compile_sol,file) # The reason why outputting to json fomat is import: the information on the ABI is very important during development


#C3. DEPLOYING: What is needed? => The 1. bytecode 2. the abi

## get the bytecode
bytecode = compile_sol["contracts"]["SimpleStorage.sol"]["SimpleStorage"]["evm"]["bytecode"]

## get the abi
abi = compile_sol["contracts"]["SimpleStorage.sol"]["SimpleStorage"]["abi"]

## private VM connection (connecting to Ganache)
w3_link = Web3(Web3.HTTPProvider("http:HTTP://127.0.0.1:7545"))# the http link can be looked up from the menu bar of the a started ganache session
chain_id = 1337
my_address = "0xE2B2ec47ac31ED2cfA8a623c90dD7820cBA5fE97" # grab one of the fake IDs from ganache
private_key = "0x71158d343dee338c503ceedd1aa5b44b25254604224b446f4ba801323a4da1f1" # Warning: bad to keep private key in source code here.

#C4. Create the contract now in python
SimpleStorage = w3_link.eth.contract(abi=abi,bytecode=bytecode)
print(SimpleStorage)