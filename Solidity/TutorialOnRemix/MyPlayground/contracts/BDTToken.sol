// SPDX-License-Identifier: MIT 
/* SPDX above stands for Software Package Data Exchange*/
//pragma solidity ^0.8.0; // this line enables us to work with any verion of 0.8
pragma solidity >=0.6.0 <0.9.0; // solidity version being useds;


import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.0.0/contracts/token/ERC20/ERC20.sol";

contract BDTToken is IERC20{
constructor (string memory _name,string memory _symbol) ERC20(_name, _symbol) public{
    
}

}