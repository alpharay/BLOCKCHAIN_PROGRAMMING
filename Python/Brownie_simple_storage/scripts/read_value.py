from brownie import config, accounts, SimpleStorage

def read_contract():
    # Q: How do we interract with the simple storage contract that we have just deployed
    # ans: The simple storage object is actually an array that we can printing out
    
    # print(SimpleStorage)
    print(SimpleStorage[0])# for first object deployed
    simple_storage = SimpleStorage[-1] # for the most recent update
    
    # Brownie automatically knows the abi and the address from the compile "build/contract/SimpleStorage.json" file
    print(simple_storage.retrieveView()) 
    

def main():
    read_contract()