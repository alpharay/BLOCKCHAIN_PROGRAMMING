// SPDX-License-Identifier: MIT 
/* SPDX above stands for Software Package Data Exchange*/
//pragma solidity ^0.8.0; // this line enables us to work with any verion of 0.8
pragma solidity >=0.6.0 <0.9.0; // solidity version being useds;


import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.0.0/contracts/token/ERC20/IERC20.sol";


contract BTDTokenSwap{
    IERC20 public token1;
    address public owner1=0xc630c6bFF4d198F30d9Ab86F89FB83F0bc3fb948;
    IERC20 public token2;
    address public owner2;
    bool transactionMade;

    constructor(address _token1, address _owner1, address _token2, address _owner2){
        token1 = IERC20(_token1);
        owner1 = _owner1;
        token2 = IERC20(_token2);
        owner2 = _owner2;
    }

    
    function swap(uint _amount1, uint _amount2) public {
    /*
    Purpose: For swapping token
    */

        require(msg.sender == owner1 || msg.sender == owner2, "Not authorized");
        require(token1.allowance(owner1, address(this)) >= _amount1, "Token 1 allowance to low");
        require(token1.allowance(owner2, address(this)) >= _amount2, "Token 2 allowance to low");

    // Transfer tokens
    // From token1, owner1, amount1 => owner2
    _saferTransferFrom(token1, owner1, owner2, _amount1);
    // From token2, owner2, amount2 => owner1
    _saferTransferFrom(token2, owner2, owner1, _amount2);
    }

    
    function _saferTransferFrom (IERC20 token, address sender, address recipient, uint amount) private{
    /*
    Purpose: To transfer token from sender to receiver
    */
        bool sent = token.transferFrom(sender, recipient, amount);
        require(sent, "Token transfer failed");
    }



   function getPrice() public pure returns (uint256){//this function gives the exchange rate between bdT and USDT from the hardcoded address
        // Hard coded
        int256 answer = 18822680;

    //     // Using price feed
    //     AggregatorV3Interface priceFeed = AggregatorV3Interface(0xc630c6bFF4d198F30d9Ab86F89FB83F0bc3fb948);/*the address was copied from the link
    //    [[https://docs.chain.link/data-feeds/price-feeds/addresses?network=ethereum&page=1#ethereum-mainnet][Sepolia TestNet]] for the specific
    //     of ETH=>USD*/
    //     //(uint80 roundId,int256 answer,uint256 startedAt,uint256 updatedAt,uint80 answeredInRound) = priceFeed.latestRoundData();//PNB: returns into a tuple like in python
    //     (,int256 answer,,,) = priceFeed.latestRoundData(); //PNB: The returning variables that are not to be used from the above line could also be left empty

        //return uint256(answer);/*'answer' is type casted from int256 to uint256; */
        /*the answer represents the number of ETH (i.e., GWEI) that matches a certain amount of dollars. This conversion could be checked using a this link
        [[https://eth-converter.com/][Simple Unit Converter]]*/
        return uint256(answer * 10000000000);//to return WEI instead of GWEI, we multiply by 10E10 b'cos 1 ETH = 10E9 GWEI
    }

   //1000000000 GWEI is used as the ethAmount for testing
    function getConversionRate(uint256 bdtAmount) public pure returns (uint256){//to convert the amount sent to USD
    uint256 bdtPrice = getPrice();
    uint256 bdtAmountInUsd = (bdtPrice * bdtAmount)/10E18; //b'cos 1 ETH = 10E9 GWEI = 10E18 WEI (the ETH is what is needed b'cos that is what has a pricing in USD)
    return bdtAmountInUsd; /* at the time of testing, 32650858802 returned but this is actually 0.000000032650858802 USD 
    by dividing on a calculator by 10E8 to confirm as solidity doesn't give us decimals*/
    }
}