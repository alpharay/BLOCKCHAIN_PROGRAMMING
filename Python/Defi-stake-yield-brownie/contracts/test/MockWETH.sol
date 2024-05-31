// SPX-License-Identifier: MIT
pragma solidity ^0.8.0;
//this is to mock the FAU token; We are going to make it a basic ERC20 token

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MockWETH is ERC20 {
    constructor() ERC20("Mock WETH", "WETH") {}
}
