from brownie import network, config, accounts, MockV3Aggregator

# from web3 import Web3

LOCAL_BLOCKCHAIN_ENVIRONMENTS = ["development", "ganache-local"]

# DECIMALS = 18
DECIMALS = 8  # for fUSD pricefeeds, this should actually be 8 decimals; this is also because in our 'getPrice' method in 'FundMe.sol' contract we actuall multiply the pricefeed ('answer') by 10**10

STARTING_PRICE = 2000e8


def get_account():
    """
    # Brownie provides access to:
    # (1) localnet via GANACHE-CLI
    # (2) To testnet and mainnet via other RPCs
    a list of network could be shown by typing: "brownie networks list"
    """

    """    
    # Determining if we are working on a local DEVELOPMENT NETWORK (via GANACHE-CLI)
    # or on an LIVE-NET (i.e., either MAINNET or TESTNET via ETHEREUM or a third party node provider like Infura.
    # This can be seen under Ethereum-Sepolia-sepolia after typing the
    # show in (2))
    """
    if (
        network.show_active() in LOCAL_BLOCKCHAIN_ENVIRONMENTS
    ):  # if we are on the development network (local-net); pull from our development network
        return accounts[0]
    else:
        return accounts.add(
            config["wallets"]["from_key"]
        )  # otherwise pull from out 'config' file(s)


def deploy_mocks():
    print(f"The active network is {network.show_active()}")
    print("Deploying Mocks...")

    if len(MockV3Aggregator) <= 0:
        # mock_aggregator = MockV3Aggregator.deploy(18,2E18,{"from":account})

        # MockV3Aggregator.deploy(
        #     DECIMALS, Web3.to_wei(STARTING_PRICE, "ether"), {"from": get_account()}
        # )  # to_wei method will add 18 decimals to 2000

        MockV3Aggregator.deploy(
            DECIMALS, STARTING_PRICE, {"from": get_account()}
        )  # we decided to use the hard coded values and not to do web3 encoding due to how we handle the 'getPrice' method in 'FundMe.sol' contract
        print("Mocks Deployed")
