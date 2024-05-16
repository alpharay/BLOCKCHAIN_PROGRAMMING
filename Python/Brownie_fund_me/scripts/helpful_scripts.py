from brownie import network, config, accounts

def get_account():
    '''
    # Brownie provides access to:
    # (1) localnet via GANACHE-CLI
    # (2) To testnet and mainnet via other RPCs
    a list of network could be shown by typing: "brownie networks list"
    '''
    
    '''    
    # Determining if we are working on a local DEVELOPMENT NETWORK (via GANACHE-CLI)
    # or on an LIVE-NET (i.e., either MAINNET or TESTNET via ETHEREUM or a third party node provider like Infura.
    # This can be seen under Ethereum-Sepolia-sepolia after typing the
    # show in (2))
    '''
    if network.show_active() == "development": # if we are on the development network (local-net); pull from our development network
        return accounts[0]
    else:
        return accounts.add(config["wallets"]["from_key"]) # otherwise pull from out 'config' file(s)