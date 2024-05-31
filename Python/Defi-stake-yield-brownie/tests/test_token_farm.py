"""
Purpose: 

1. For testing our TokenFarm.sol contract. Ideally we want to write some tests for our "DappToken.sol"
contract as well but we are basically doing openzeppelin's implementation so we can skip it. On a full scale production
however, we may probably want to write some tests for the DappToken.sol contract.

2. writes tests every piece of code(i.e., "function") in DappToken.sol
"""

from brownie import network, exceptions
import pytest
from scripts.helpful_scripts import (
    LOCAL_BLOCKCHAIN_ENVIRONMENTS,
    INITIAL_PRICE_FEED_VALUE,
    get_account,
    get_contract,
)
from scripts.deploy import deploy_token_farm_and_dapp_token


def test_set_price_feed_contract():
    # PHASE 1: (A)RRANGE
    # Let's make sure that we are on a local network
    if network.show_active() not in LOCAL_BLOCKCHAIN_ENVIRONMENTS:
        pytest.skip("Only for local testing!")
    account = get_account()  # grab an account
    non_owner = get_account(
        index=1
    )  # grab also a non-owner account to give us a different account from the one just above
    token_farm, dapp_token = deploy_token_farm_and_dapp_token()

    # PHASE 2: (A)CT PHASE
    price_feed_address = get_contract("eth_usd_price_feed")
    token_farm.setPriceFeedContract(
        dapp_token.address, price_feed_address, {"from": account}
    )

    # PHASE 3: (A)SSERT PHASE
    # if we check our price-feed mapping done in the setPriceFeedContract' method, 'tokenPriceFeedMapping[_token]' should be updated
    assert token_farm.tokenPriceFeedMapping(dapp_token.address) == price_feed_address

    # We also want to make sure that non-owners cannot call this function
    with pytest.raises(exceptions.VirtualMachineError):
        # token_farm.setPriceFeedContract(
        #     dapp_token.address, price_feed_address, {"from": account}
        # )  # this should fail

        token_farm.setPriceFeedContract(
            dapp_token.address, price_feed_address, {"from": non_owner}
        )  # this should pass


def test_stake_tokens(amount_staked):
    """_summary_

    Args:
        amount_staked (fixture): fixtures are necessary when you want to reuse some generated data/functionality for multiple tests
    """
    # PHASE 1: (A)RRANGE
    # Let's make sure that we are on a local network
    if network.show_active() not in LOCAL_BLOCKCHAIN_ENVIRONMENTS:
        pytest.skip("Only for local testing!")
    account = get_account()

    token_farm, dapp_token = deploy_token_farm_and_dapp_token()

    # PHASE 2: (A)CT
    # Let's actually go ahead and act (in this case send some tokens to our TokenFarm)
    dapp_token.approve(
        token_farm.address, amount_staked, {"from": account}
    )  # PNB: for a token, we first need to call the 'approve' method virtually first all the time
    token_farm.stakeTokens(
        amount_staked, dapp_token.address, {"from": account}
    )  # now we can stake the token

    # PHASE 3. (A)SSERT; We have a number of assertions to make here because our state token functions does a number of things so we have to check all
    assert (
        token_farm.stakingBalance(dapp_token.address, account.address) == amount_staked
    )  # 'stakingBalance' is a mapping found in our TokenFarm contract and because it is an address to an address, we syntactically passed those addresses from outside the contract as two parameters in contrast to as two indices as was done when we are in the 'TokenFarm.sol' file
    assert (
        token_farm.uniqueTokensStaked(account.address) == 1
    )  # this is going to be the first token so it should have unique token state
    assert token_farm.stakers(0) == account.address
    return token_farm, dapp_token


def test_issue_tokens(amount_staked):
    """_summary_
    In order to test issuing tokens, we actually need to stake some tokens first. So we have
    to write the 'test_stake_tokens()' test first
    """
    # PHASE 1: (A)RRANGE
    # Let's make sure that we are on a local network
    if network.show_active() not in LOCAL_BLOCKCHAIN_ENVIRONMENTS:
        pytest.skip("Only for local testing!")
    account = get_account()

    token_farm, dapp_token = test_stake_tokens(amount_staked)
    starting_balance = dapp_token.balanceOf(
        account.address
    )  # we need to know the balance that was originally there

    # PHASE 2: (A)CT
    token_farm.issueTokens({"from": account})

    # PHASE 3. (A)SSERT
    # We are staking 1 dapp_token == in price to 1 ETH
    # soo... we should get 2,000 dapp tokens in reward
    # since the price is 2,000 USD
    assert (
        dapp_token.balanceOf(account.address)
        == starting_balance + INITIAL_PRICE_FEED_VALUE
    )
