from scripts.helpful_scripts import get_account, get_contract, debugging_print
from brownie import DappToken, TokenFarm, config, network
from web3 import Web3
import yaml
import json
import os
import shutil

KEPT_BALANCE = Web3.to_wei(100, "ether")


def deploy_token_farm_and_dapp_token(front_end_update=False):
    account = (
        get_account()
    )  # first thing that we want to do - as always - is to get our account
    dapp_token = DappToken.deploy({"from": account})
    token_farm = TokenFarm.deploy(
        dapp_token.address,
        {"from": account},
        publish_source=config["networks"][network.show_active()]["verify"],
    )  # Once we've deployed this token farm contract, we need to send it some dapp tokens so that we can get those tokens out as rewards
    debugging_print("Active Networks", network.show_active())
    debugging_print("Dapp token Address", dapp_token.address)

    # --- A. We first can send all or our total supply but we need to keep some for things like testing ---
    tx = dapp_token.transfer(
        token_farm.address, dapp_token.totalSupply() - KEPT_BALANCE, {"from": account}
    )
    tx.wait(1)

    # --- B. We then need to see the tokens that are allowed (this automatically means that we would need their pricefeed as well) ---
    # Tokens to be allowed
    # 1. Our dapp_token
    # 2. weth_token (weth=> wrapped eth): because that is pretty much a standard in most smart contract platforms
    # 3. fau_token (fau => faucet): we use this because there's erc20faucet.com that allows us to get this fake faucet token. We are going to pretend that this faucet token is DAI token; Check time 13:36:56 of video tutorial
    weth_token = get_contract(
        "weth_token"  # this string needs to match that in our config
    )  # we could have done 'weth_token = config["networks"]' and always get it from our 'brownie-config file' but we want to be able to deploy our own fake weth_token so that we can test it locally. We'll therefore use 'get_contract' from our helpful_scripts.py
    fau_token = get_contract("fau_token")

    # --- C. DEPLOYING THE PRICE-FEEDS IF THEY DON'T ALREADY EXIST---
    dict_of_allowed_tokens = {
        dapp_token: get_contract(
            "dai_usd_price_feed"
        ),  # in dai; ensure that this is found in your mocks and also are deployed via the 'deploy_mocks' function and also added to the 'contract_to_mock' variable all in your 'helpful_scripts.py' file
        fau_token: get_contract(
            "dai_usd_price_feed"
        ),  # in dai; ensure that this is found in your mocks and also are deployed via the 'deploy_mocks' function and also added to the 'contract_to_mock' variable all in your 'helpful_scripts.py' file
        weth_token: get_contract(
            "eth_usd_price_feed"
        ),  # in weth; ensure that this is found in your mocks and also are deployed via the 'deploy_mocks' function and also added to the 'contract_to_mock' variable all in your 'helpful_scripts.py' file
    }

    add_allowed_tokens(token_farm, dict_of_allowed_tokens, account)
    if front_end_update:
        update_front_end()
    return (
        token_farm,
        dapp_token,
    )  # returning these two so that we can use our deploy script in our test


def add_allowed_tokens(token_farm, dict_of_allowed_tokens, account):
    """
    To loop through each token and call the 'addAllowedToken' function
    """
    for token in dict_of_allowed_tokens:
        # call 'addAllowedTokens'
        add_tx = token_farm.addAllowedTokens(token.address, {"from": account})
        add_tx.wait(1)

        # call 'setPriceFeedContract' to set the price feed associated with the contract
        set_tx = token_farm.setPriceFeedContract(
            token.address, dict_of_allowed_tokens[token], {"from": account}
        )
        set_tx.wait(1)
    return token_farm


def update_front_end():
    # --- COPYING KEY FOLDERS ---
    # Sending our 'build' folder to the 'src' folder of our 'front_end'
    copy_folders_to_front_end("./build", "./front_end/src/chain-info")

    # --- COPYING KEY FILES ---
    # Sending our 'brownie-config.yaml' file as a .json file to the 'src' folder of our front_end folder as typescript doesn't work well with yaml files
    with open("brownie-config.yaml", "r") as brownie_config:
        config_dict = yaml.load(
            brownie_config, Loader=yaml.FullLoader
        )  # the 'yaml' package here will allow us to load our yaml into a dictionary
        with open("./front_end/src/brownie-config.json", "w") as brownie_config_json:
            json.dump(config_dict, brownie_config_json)
    print("Front end updated")


def copy_folders_to_front_end(src, dest):
    if os.path.exists(dest):  # checking to see if the destination already exists
        shutil.rmtree(dest)  # delete the destination if it already exists
    shutil.copytree(src, dest)


def main():
    deploy_token_farm_and_dapp_token(front_end_update=True)
