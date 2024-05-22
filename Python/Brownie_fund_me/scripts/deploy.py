from brownie import FundMe, MockV3Aggregator, network, config
from scripts.helpful_scripts import (
    get_account,
    deploy_mocks,
    LOCAL_BLOCKCHAIN_ENVIRONMENTS,
)


# from brownie.network import gas_price
# from brownie.network.gas.strategies import LinearScalingStrategy

# gas_strategy = LinearScalingStrategy("20 gwei", "30 gwei", 1.1, time_duration=5)


def deploy_fund_me():  # making our deployment live-net / local-net (development-net) agnostic
    account = get_account()
    if network.show_active() not in LOCAL_BLOCKCHAIN_ENVIRONMENTS:
        # gas_price(gas_strategy)
        price_feed_address = config["networks"][network.show_active()][
            "eth_usd_price_feed"
        ]
    else:  # deploy our own local data-feeds
        deploy_mocks()
        # price_feed_address = mock_aggregator.address
        price_feed_address = MockV3Aggregator[
            -1
        ].address  # use the most recently deployed "Mockv3Aggregator"

    # fund_me = FundMe.deploy({"from": account})

    fund_me = FundMe.deploy(
        price_feed_address,
        {"from": account},
        publish_source=config["networks"][network.show_active()].get("verify"),
    )

    # fund_me = FundMe.deploy(
    #     price_feed_address,
    #     {"from": account, "gas_price": gas_strategy},
    #     publish_source=config["networks"][network.show_active()].get("verify"),
    # )  # 'publish_source=config["networks"][network.show_active()].get("verify")' is used instead of 'publish_source=config["networks"][network.show_active()]["verify"]' because in the later you can run into some indexing error if you forget to verify

    print(f"Contract deployed to {fund_me.address}")
    return fund_me


def main():
    deploy_fund_me()
