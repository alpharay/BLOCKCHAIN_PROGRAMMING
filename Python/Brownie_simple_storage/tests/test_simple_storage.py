from brownie import SimpleStorage, accounts

'''
Testing has to do with three main steps (RED-GREEN-REFACTOR)
[[https://www.youtube.com/watch?v=B1j6k2j2eJg][Test-Driven Development (TDD) In Python // The Power of Red-Green-Refactor]]
------------------ 
RED-GREEN-REFACTOR
------------------
1. Write and run tests making sure all tests should fail ===> RED
2. Twin test pass ===> GREEN
    3.1 NEW TEST PASS: Write simplest version of actual code and make sure should pass
    3.2 ALL TEST (NEW TEST + OLD TEST) PASS: Make sure that all tests pass, including older tests you may have
3. Refactor and improve code: ===> REFACTION
Improve code and make sure every refactored iteration also passes the tests
'''


'''
A variant of RGR  that we'll use here are
1. Arrage 
2. Act 
3. Assert
'''
def test_deploy():
    # Arrange: Set up all pieces needed to be set up
    account = accounts[0]
    
    # Act
    simple_storage = SimpleStorage.deploy({"from":account})
    starting_value = simple_storage.retrieveView()
    expected = 0
    
    # Assert
    assert starting_value == expected
    

def test_updating_storage():
    # Arrange
    account = accounts[0]
    simple_storage = SimpleStorage.deploy({"from":account})
    
    # Act 
    expected = 15
    simple_storage.store(expected,{"from":account})
    
    # Assert
    assert expected == simple_storage.retrieveView()