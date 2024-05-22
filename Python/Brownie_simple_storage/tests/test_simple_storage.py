from brownie import SimpleStorage, accounts

"""
Testing has to do with three main objectives (RED-GREEN-REFACTOR)
[[https://www.youtube.com/watch?v=B1j6k2j2eJg][Test-Driven Development (TDD) In Python // The Power of Red-Green-Refactor]]
------------------ 
RED-GREEN-REFACTOR
------------------
1. Write and run tests making sure all tests should fail ===> RED
2. Twin test pass ===> GREEN
    2.1 NEW TEST PASS: Write simplest version of actual code and make sure should pass
    2.2 ALL TEST (NEW TEST + OLD TEST) PASS: Make sure that all tests pass, including older tests you may have
3. Refactor and improve code: ===> REFACTION
Improve code and make sure every refactored iteration also passes the tests.

Whereas the RGR framework gives a structure of goals to be met by all test functions in a time instance,
the 3A's framework details the actual steps carried out in implement the actual functions for carring out the tests
"""


"""
In writing a test method, one has to carry out 3 actions:
3A's
1. Arrange 
2. Act 
3. Assert
"""


def test_deploy():
    # Arrange: Set up all pieces needed to be set up
    account = accounts[0]

    # Act: Carry out the needed action needed
    simple_storage = SimpleStorage.deploy({"from": account})
    starting_value = simple_storage.retrieveView()
    expected = 0

    # Assert: perform the foundation boolean check
    assert starting_value == expected


def test_updating_storage():
    # Arrange
    account = accounts[0]
    simple_storage = SimpleStorage.deploy({"from": account})

    # Act
    expected = 15
    simple_storage.store(expected, {"from": account})

    # Assert
    assert expected == simple_storage.retrieveView()
