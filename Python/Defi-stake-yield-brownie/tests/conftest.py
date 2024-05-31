import pytest
from web3 import Web3


# We have to get used to using fixtures in our pytest
@pytest.fixture
def amount_staked():  # this is passed as a parameter in our 'test_stake_tokens' test function
    return Web3.to_wei(1, "ether")  # the 'to_wei' function used to be 'toWei'
