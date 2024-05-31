// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC20 {
    function transfer(address recipient, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
}

contract BDTPreSale {
    address public owner;
    address public bdtToken;
    address public usdtToken;

    uint256 public constant BDT_USDT_RATE = 7300000; // 1 BDT = 0.0073 USDT (6 decimals)
    uint256 public constant BDT_ETH_RATE = 1910000000000; // 1 BDT = 0.00000191 ETH (18 decimals)

    event TokensPurchased(address indexed buyer, uint256 amount, string currency);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can execute this");
        _;
    }

    constructor(address _bdtToken, address _usdtToken) {
        owner = 0x55585E22Ccd9cc2B4563Ba44e8a57867464b6250;
        bdtToken = _bdtToken;
        usdtToken = _usdtToken;
    }

    function buyWithUSDT(uint256 usdtAmount) external {
        require(usdtAmount > 0, "Amount must be greater than zero");
        
        uint256 bdtAmount = (usdtAmount * 1e6) / BDT_USDT_RATE;
        require(IERC20(bdtToken).balanceOf(address(this)) >= bdtAmount, "Not enough BDT tokens in the contract");
        
        require(IERC20(usdtToken).transferFrom(msg.sender, owner, usdtAmount), "USDT transfer failed");
        require(IERC20(bdtToken).transfer(msg.sender, bdtAmount), "BDT transfer failed");

        emit TokensPurchased(msg.sender, bdtAmount, "USDT");
    }

    function buyWithETH() external payable {
        require(msg.value > 0, "Amount must be greater than zero");
        
        uint256 bdtAmount = (msg.value * 1e18) / BDT_ETH_RATE;
        require(IERC20(bdtToken).balanceOf(address(this)) >= bdtAmount, "Not enough BDT tokens in the contract");

        payable(owner).transfer(msg.value);
        require(IERC20(bdtToken).transfer(msg.sender, bdtAmount), "BDT transfer failed");

        emit TokensPurchased(msg.sender, bdtAmount, "ETH");
    }

    function withdrawTokens(uint256 amount) external onlyOwner {
        require(IERC20(bdtToken).balanceOf(address(this)) >= amount, "Not enough BDT tokens in the contract");
        require(IERC20(bdtToken).transfer(owner, amount), "BDT transfer failed");
    }

    function withdrawETH() external onlyOwner {
        payable(owner).transfer(address(this).balance);
    }

    function withdrawUSDT(uint256 amount) external onlyOwner {
        require(IERC20(usdtToken).balanceOf(address(this)) >= amount, "Not enough USDT tokens in the contract");
        require(IERC20(usdtToken).transfer(owner, amount), "USDT transfer failed");
    }
}