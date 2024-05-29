//SPDX-License-Identifier: MIT
pragma solidity >=0.6.12 <0.9.0;

import "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol"; //importing and using datafeeds from chainlink

/*
'msg' keyword gives access to global variables which provide access to properties of the blockchain
'msg.sender': helps you get who is sender of the message (i.e. the current call). PNB: could be the contract owner or any person "interracting" with the contract at that moment
'this' keyword: referes to contract that one is currently in
*/

contract BDTFundMe{//PNB: So here now we can fund a certain account, i.e. 'addressToAmountFunded' with our GWEI value
    mapping(address => uint256) public addressToAmountFunded;
    address[] public funders;
    address public owner;

    constructor () {
    owner = msg.sender; // this represents whoever deployed the smart contract (i.e. the smart contract owner)   
    }

    function Fund () public payable {//to send ETH funds to an address/account
        //setting a minimum threshold of $2 that is sendable
        uint256 minimumUSD = 0.03 * 10**18; //Converting from USD to WEI; '10**X' is the same as '10EX'
        require(getConversionRate(msg.value) >= minimumUSD, "You need to spend more ETH!");// you can accomplish this with an 'if-else' statement but the 'require' function makes this cleaner
        addressToAmountFunded[msg.sender] += msg.value;
        funders.push(msg.sender);

        /*Now we need to be able to convert between ETH (GWEI) and USD if these transactions are going to have real world equivalence and impact. How
        are we going to get ETH => USD conversions. Remember Oracles and the Oracle problem, here is where the come into play*/
    }

    modifier onlyOwner {// this modifier ensures that only the owner who called the smart contract can perform a certain function on which it is used
      require(msg.sender == owner);
      _;// this underscore means run the code within the function on which this modifier would be used. Note that the underscore could also come before the 'require' method  
    }

    function withdraw() public onlyOwner payable {// to withdraw ETH funds from an address/account
        //msg.sender.transfer(address(this).balance); /*for Solidity version >=0.8.0 this line does not work for calls to 'send()' and 'transfer()'. Instead */
        /*as below the address has to be cast to a payable address*/        
        payable(msg.sender).transfer(address(this).balance);// this line means, whoever called this 'withdraw()' function (i.e., msg.sender), transfer all of our money to them
        for(uint256 funderIndex=0; funderIndex < funders.length; funderIndex++){//setting amount to zero after withdrawing from funders
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }
        funders = new address[](0);//resetting the funders array so that new funders who come after the withdrawal are not sent to that address
    }

    function getVersion() public view returns (uint256){//this function calls the 'version()' function defined in the 'AggregatorV3Interface' contract
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0xc630c6bFF4d198F30d9Ab86F89FB83F0bc3fb948);/*the address was copied from the link
        [[https://docs.chain.link/data-feeds/price-feeds/addresses?network=ethereum&page=1#ethereum-mainnet][Sepolia TestNet]] for the specific
        of ETH=>USD*/
        return priceFeed.version();
    }

    function getPrice() public view returns (uint256){//this function calls the 'latestRoundData()' function defined in the 'AggregatorV3Interface' contract
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0xc630c6bFF4d198F30d9Ab86F89FB83F0bc3fb948);/*the address was copied from the link
       [[https://docs.chain.link/data-feeds/price-feeds/addresses?network=ethereum&page=1#ethereum-mainnet][Sepolia TestNet]] for the specific
        of ETH=>USD*/
        //(uint80 roundId,int256 answer,uint256 startedAt,uint256 updatedAt,uint80 answeredInRound) = priceFeed.latestRoundData();//PNB: returns into a tuple like in python
        (,int256 answer,,,) = priceFeed.latestRoundData(); //PNB: The returning variables that are not to be used from the above line could also be left empty

        //return uint256(answer);/*'answer' is type casted from int256 to uint256; */
        /*the answer represents the number of ETH (i.e., GWEI) that matches a certain amount of dollars. This conversion could be checked using a this link
        [[https://eth-converter.com/][Simple Unit Converter]]*/
        return uint256(answer * 10000000000);//to return WEI instead of GWEI, we multiply by 10E10 b'cos 1 ETH = 10E9 GWEI
    }

    //1000000000 GWEI is used as the ethAmount for testing
    function getConversionRate(uint256 ethAmount) public view returns (uint256){//to convert the amount sent to USD
    uint256 ethPrice = getPrice();
    uint256 ethAmountInUsd = (ethPrice * ethAmount)/10E18; //b'cos 1 ETH = 10E9 GWEI = 10E18 WEI (the ETH is what is needed b'cos that is what has a pricing in USD)
    return ethAmountInUsd; /* at the time of testing, 32650858802 returned but this is actually 0.000000032650858802 USD 
    by dividing on a calculator by 10E8 to confirm as solidity doesn't give us decimals*/
    }
}