// SPDX-License-Identifier: MIT
/* SPDX above stands for Software Package Data Exchange*/
//pragma solidity ^0.8.0; // this line enables us to work with any verion of 0.8
pragma solidity >=0.6.0 <0.9.0; // solidity version being useds;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.0.0/contracts/token/ERC20/IERC20.sol";

contract BTDTokenSwap {
    IERC20 public tokenBDT;
    address public ownerBDT = 0x55585E22Ccd9cc2B4563Ba44e8a57867464b6250;

    IERC20 public tokenUSDT;
    address public ownerUSDT;

    IERC20 public tokenETH;
    address public ownerETH;

    uint256 public constant BDT_USDT_RATE = 7300000; // 1 BDT = 0.0073 USDT (6 decimals)
    uint256 public constant BDT_ETH_RATE = 1910000000000; // 1 BDT = 0.00000191 ETH (18 decimals)
    
    event TokensPurchased(address indexed buyer, uint256 amount, string currency);
    

    // constructor(address _token1, address _owner1, address _token2, address _owner2){
    //     tokenBDT = IERC20(_token1);
    //     ownerBDT = _owner1;
    //     tokenUSDT = IERC20(_token2);
    //     ownerUSDT = _owner2;
    // }

    //constructor(address _tokenBDT, address _tokenUSDT){
    //ownerBDT = 0x55585E22Ccd9cc2B4563Ba44e8a57867464b6250;
    //tokenBDT = IERC20(_tokenBDT);
    //tokenUSDT = IERC20(_tokenUSDT);
    //}

    function _safeBuyWithUSDT(address _tokenBDT, address _tokenUSDT,uint256 _amountUSDT) external payable {
    ownerBDT = 0x55585E22Ccd9cc2B4563Ba44e8a57867464b6250;
    tokenBDT = IERC20(_tokenBDT);
    tokenUSDT = IERC20(_tokenUSDT);

        require(_amountUSDT > 0, "Amount must be greater than zero");

        uint256 bdtAmount = (_amountUSDT * 1e6) / BDT_USDT_RATE;
        require(
            tokenBDT.balanceOf(address(this)) >= bdtAmount,
            "Not enough BDT tokens in the contract"
        );

        require(
            tokenUSDT.transferFrom(msg.sender, ownerBDT, _amountUSDT),
            "USDT transfer failed"
        );
        require(
            tokenBDT.transfer(msg.sender, bdtAmount),
            "BDT transfer failed"
        );

        emit TokensPurchased(msg.sender, bdtAmount, "USDT");
    }

    function _safeBuyWithETH(address _tokenBDT, address _tokenETH,uint256 _amountETH) external payable{
    ownerBDT = 0x55585E22Ccd9cc2B4563Ba44e8a57867464b6250;
    tokenBDT = IERC20(_tokenBDT);
    tokenETH = IERC20(_tokenETH);

        require(_amountETH > 0, "Amount must be greater than zero");

        uint256 bdtAmount = (_amountETH * 1e6) / BDT_ETH_RATE;
        require(
            tokenBDT.balanceOf(address(this)) >= bdtAmount,
            "Not enough BDT tokens in the contract"
        );

        require(
            tokenETH.transferFrom(msg.sender, ownerBDT, _amountETH),
            "USDT transfer failed"
        );
        require(
            tokenBDT.transfer(msg.sender, bdtAmount),
            "BDT transfer failed"
        );

        emit TokensPurchased(msg.sender, bdtAmount, "USDT");
    }




    // function swap(uint256 _amount1, uint256 _amount2) public {
    //     /*
    // Purpose: For swapping token
    // */

    //     require(msg.sender == ownerBDT || msg.sender == ownerUSDT, "Not authorized");
    //     require(
    //         tokenBDT.allowance(ownerBDT, address(this)) >= _amount1,
    //         "Token 1 allowance to low"
    //     );
    //     require(
    //         tokenUSDT.allowance(ownerUSDT, address(this)) >= _amount2,
    //         "Token 2 allowance to low"
    //     );

    //     // Transfer tokens
    //     // From tokenBDT, ownerBDT, amount1 => ownerUSDT
    //     _saferTransferFromUSDT(tokenBDT, ownerBDT, ownerUSDT, _amount1);
    //     // From tokenUSDT, ownerUSDT, amount2 => ownerBDT
    //     _saferTransferFromUSDT(tokenUSDT, ownerUSDT, ownerBDT, _amount2);
    // }

    // function _saferTransferFromUSDT(
    //     IERC20 _tokenUSDT,
    //     address sender,
    //     address recipient,
    //     uint256 amountUSDT
    // ) private {
    //     /*
    // Purpose: To transfer token from sender to receiver
    // */
    //     tokenUSDT = _tokenUSDT;
    //     require(amountUSDT > 0, "Amount must be greater than zero");
    //     bool sent = tokenUSDT.transferFrom(sender, recipient, amountUSDT);
    //     require(sent, "Token transfer failed");
    // }

    // function _saferTransferFromBDT(
    //     IERC20 _tokenBDT,
    //     address sender,
    //     address recipient,
    //     uint256 amountBDT
    // ) private {
    //     /*
    // Purpose: To transfer token from sender to receiver
    // */
    //     tokenBDT = _tokenBDT;
    //     require(amountBDT > 0, "Amount must be greater than zero");
    //     bool sent = tokenBDT.transferFrom(sender, recipient, amountBDT);
    //     require(sent, "Token transfer failed");
    // }

   



    // function getPrice() public pure returns (uint256) {
    //     //this function gives the exchange rate between bdT and USDT from the hardcoded address
    //     // Hard coded
    //     int256 answer = 18822680;

    //     //     // Using price feed
    //     //     AggregatorV3Interface priceFeed = AggregatorV3Interface(0xc630c6bFF4d198F30d9Ab86F89FB83F0bc3fb948);/*the address was copied from the link
    //     //    [[https://docs.chain.link/data-feeds/price-feeds/addresses?network=ethereum&page=1#ethereum-mainnet][Sepolia TestNet]] for the specific
    //     //     of ETH=>USD*/
    //     //     //(uint80 roundId,int256 answer,uint256 startedAt,uint256 updatedAt,uint80 answeredInRound) = priceFeed.latestRoundData();//PNB: returns into a tuple like in python
    //     //     (,int256 answer,,,) = priceFeed.latestRoundData(); //PNB: The returning variables that are not to be used from the above line could also be left empty

    //     //return uint256(answer);/*'answer' is type casted from int256 to uint256; */
    //     /*the answer represents the number of ETH (i.e., GWEI) that matches a certain amount of dollars. This conversion could be checked using a this link
    //     [[https://eth-converter.com/][Simple Unit Converter]]*/
    //     return uint256(answer * 10000000000); //to return WEI instead of GWEI, we multiply by 10E10 b'cos 1 ETH = 10E9 GWEI
    // }

    // //1000000000 GWEI is used as the ethAmount for testing
    // function getConversionRate(uint256 bdtAmount)
    //     public
    //     pure
    //     returns (uint256)
    // {
    //     //to convert the amount sent to USD
    //     uint256 bdtPrice = getPrice();
    //     uint256 bdtAmountInUsd = (bdtPrice * bdtAmount) / 10E18; //b'cos 1 ETH = 10E9 GWEI = 10E18 WEI (the ETH is what is needed b'cos that is what has a pricing in USD)
    //     return bdtAmountInUsd; /* at the time of testing, 32650858802 returned but this is actually 0.000000032650858802 USD 
    // by dividing on a calculator by 10E8 to confirm as solidity doesn't give us decimals*/
    // }
}
