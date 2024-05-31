from brownie import (
    config,
    accounts,
    network,
    Contract,
    LinkToken,
    MockV3Aggregator,
    MockDAI,
    MockWETH,
)

# PNB: added this to be able to deploy to local ganache chain; to solve problem of getting stuck at 'Awaiting transaction in the mempool'.
from brownie.network import gas_price
from brownie.network.gas.strategies import LinearScalingStrategy


NON_FORKED_LOCAL_BLOCKCHAIN_ENVIRONMENTS = ["hardhat", "development", "ganache"]
LOCAL_BLOCKCHAIN_ENVIRONMENTS = NON_FORKED_LOCAL_BLOCKCHAIN_ENVIRONMENTS + [
    "mainnet-fork",
    "binance-fork",
    "matic-fork",
]  # PNB: consists of both installed local networks (non-forked networks; given by say ganache) as well as forked local networks

INITIAL_PRICE_FEED_VALUE = 2000_00000000_0000000000
DECIMALS = 18  # PNB: This is 18 and not 8. The later will result in a test error with 'test_issue_tokens' function in 'test_token_farm.py'
# INITIAL_VALUE = 2000

contract_to_mock = {
    "eth_usd_price_feed": MockV3Aggregator,
    "dai_usd_price_feed": MockV3Aggregator,
    "fau_token": MockDAI,
    "weth_token": MockWETH,
}


def get_account(index=None, id=None):  # to get our accounts easily
    if index:
        return accounts[index]
    if network.show_active() in LOCAL_BLOCKCHAIN_ENVIRONMENTS:
        gas_strategy = LinearScalingStrategy(
            "60 gwei", "70 gwei", 1.1
        )  # PNB: added this to be able to deploy to local ganache chain; to solve problem of getting stuck at 'Awaiting transaction in the mempool'.
        gas_price(gas_strategy)
        return accounts[0]
    if id:
        return accounts.load(id)
    return accounts.add(config["wallets"]["from_key"])


def get_contract(contract_name):
    contract_type = contract_to_mock[contract_name]
    if network.show_active() in NON_FORKED_LOCAL_BLOCKCHAIN_ENVIRONMENTS:
        if len(contract_type) <= 0:
            deploy_mocks()
        contract = contract_type[-1]
        # debugging_print("Contract", contract)
    else:
        try:
            contract_address = config["networks"][network.show_active()][contract_name]
            contract = Contract.from_abi(
                contract_type._name, contract_address, contract_type.abi
            )
        except KeyError:
            print(
                f"{network.show_active()} address not found, perhaps you should add it to the config or deploy mocks"
            )
            print(
                f"brownie run scripts/deploy_mocks.py --network {network.show_active()}"
            )
    return contract


def deploy_mocks(decimals=DECIMALS, initial_value=INITIAL_PRICE_FEED_VALUE):
    """
    Use the script if you want to deploy mocks to the testnet
    """
    print(f"The active network is {network.show_active()}")

    print("Deploying mocks")  # Mock Account deployment
    account = get_account()

    print("Deploying Mock Link Token...")
    link_token = LinkToken.deploy({"from": account})  # Mock Link token deployment

    print("Deploying Mock Price Feed...")  # Mock Price Feed deployment
    mock_price_feed = MockV3Aggregator.deploy(
        decimals, initial_value, {"from": account}
    )
    print(f"Deployed to {mock_price_feed.address}")

    print("deploying Mock DAI...")  # Mock DAI token deployment
    dai_token = MockDAI.deploy({"from": account})
    print(f"Deploying to {dai_token.address}")

    print("deploying Mock WETH...")  # Mock WETH token deployment
    weth_token = MockWETH.deploy({"from": account})
    print(f"Deploying to {weth_token.address}")

    print("Mocks Deployed!!!")


# PNB: Functions I added
def debugging_print(_description, variable):
    print("\n", "----" * 10, "\n")
    print(f"{_description}: {variable}")
    print("\n", "----" * 10, "\n")
