// SPDX-License-Identifier: MIT

//pragma solidity  ^0.8.0;
pragma solidity >=0.6.12 <0.9.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

contract OceanToken is ERC20Capped, ERC20Burnable {
    address payable owner; // we are declaring an owner variable here so that we can use it throughout the lifetime of our smart contract to refer to the deployer of our smart contract.
    uint256 public blockReward;

    /*
GENERAL NOTES
The "_" symbol before functions symbolize that our function is calling a function in a contract we are inheriting from
*/

    // modifiers
    modifier onlyOwner() {
        //we want to make somethings available to only the owner specific smart contract although that function may be public
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }

    constructor(
        uint256 cap,
        uint256 reward
    ) ERC20("BitDonationToken", "BDT") ERC20Capped(cap * (10 ** decimals())) {
        owner = payable(msg.sender);
        _mint(owner, 70000000 * (10 ** decimals()));
        blockReward = reward * (10 ** (decimals())); //setting our block reward
    }

    function mint(address account, uint256 amount) public {
        require(
            ERC20.totalSupply() + amount <= cap(),
            "ERC20Capped: cap exceeded"
        );
        super._mint(account, amount);
    }

    //other functions
    function _mintMinerReward() internal {
        //This is "internal" because we do not want it to be called from outside this contract
        _mint(block.coinbase, blockReward); //the parameters here are "to and amount". For the "to", we want it to be the account of the node which is including the block in the blockchain (we will access hat with the global variable "block" and then use "coinbase")
    }

    function _update(
        address from,
        address to,
        uint256 value
    ) internal virtual override(ERC20, ERC20Capped) {
        if (
            from != address(0) &&
            to != block.coinbase &&
            block.coinbase != address(0)
        ) {
            // "address(0)" is a check to make sure that it is a valid address. The second check ("to != block.coinbase") is to make sure that we do not send another reward for the initial reward after it has been sent; creating an infinite loop in the process. The last check is also to make sure that the "block.coinbase" is also a valid address
            _mintMinerReward();
        }
        super._update(from, to, value);
    }

    function destroy() public onlyOwner {
        //for good practice we would want to add a method to enable us to destroy this contract in future when we no longer have need for it. Otherwise it will leave forever
        selfdestruct(owner);
    }

    //setter and getter function

    function setBlockReward(uint256 reward) public onlyOwner {
        //creating a function to set the block reward if we decide to change it later
        blockReward = reward * (10 ** decimals());
    }
}
