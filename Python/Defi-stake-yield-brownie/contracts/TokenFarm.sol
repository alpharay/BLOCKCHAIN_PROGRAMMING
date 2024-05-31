// SPDX-Liense-Idenfier: MIT
pragma solidity 0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol"; // we need the ABI to be able to call the ERC20; We are using the IERC20 here because we do not need the entire contract
import "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

contract TokenFarm is Ownable {
    //To keep track of how much token has been stake by each address (i.e. token address -> staker address -> amount)
    mapping(address => mapping(address => uint256)) public stakingBalance; //PNB: this is just a mapping a not an array/list so we cannot loop through it
    mapping(address => uint256) public uniqueTokensStaked; //PNB: to map the user to his/her unique tokens stokes; We can know how may different tokens this address actually have in state
    mapping(address => address) public tokenPriceFeedMapping; //PNB: mapping a taken to the associated priceFeed
    address[] public stakers; //gives us a list of all the stakers on the platform
    address[] public allowedTokens;
    IERC20 public dappToken;

    constructor(address _dappTokenAddress) {
        // right when we deploy this contract, we need to know the address of the DAPP token; the address of the reward token we intend to give out
        dappToken = IERC20(_dappTokenAddress);
    }

    /* 
    THINGS EXPECTED IN THIS CONTRACT
    stakeTokens - (DONE!)
    unStakeTokens
    issueTokens: a reward we give to our users for using our platform - (DONE!)
    addAllowedTokens - (DONE!)
    getValue - (DONE!)*/

    function setPriceFeedContract(
        address _token,
        address _priceFeed
    ) public onlyOwner {
        //to set the pricefeed contracts
        tokenPriceFeedMapping[_token] = _priceFeed;
    }

    function issueTokens() public onlyOwner {
        //this is a function only callable by the admin or owner of this contract ('onlyOwner')

        // Issue tokens to all stakers
        for (
            uint256 stakersIndex = 0;
            stakersIndex < stakers.length;
            stakersIndex++
        ) {
            address recipient = stakers[stakersIndex]; // grab a recipient
            uint256 userTotalValue = getUserTotalValue(recipient);
            // send them a token reward
            dappToken.transfer(recipient, userTotalValue);
            // based on their total value locked
        }
    }

    function getUserTotalValue(address _user) public view returns (uint256) {
        //; here is where we are going to do a lot of looping
        uint256 totalValue = 0;
        require(uniqueTokensStaked[_user] > 0, "No tokens staked!");
        for (
            uint256 allowedTokensIndex = 0;
            allowedTokensIndex < allowedTokens.length;
            allowedTokensIndex++
        ) {
            totalValue =
                totalValue +
                getUserSingleTokenValue(
                    _user,
                    allowedTokens[allowedTokensIndex]
                );
        }
        return totalValue;
    }

    function getUserSingleTokenValue(
        address _user,
        address _token
    ) public view returns (uint256) {
        if (uniqueTokensStaked[_user] <= 0) {
            return 0;
        }
        //price of the token * stakingBalance[_token][user]
        (uint256 price, uint256 decimals) = getTokenValue(_token);
        /*
        For e.g.
        Say given 10000000000000000000 ETH
        , at conversion ETH->USD is 10000000000, 
        then we have 10*100= 1000
         */
        return ((stakingBalance[_token][_user] * price) / 10 ** decimals);
    }

    function getTokenValue(
        address _token
    ) public view returns (uint256, uint256) {
        //priceFeedAddress needed; so we have to map tokens to their associated price feeds
        address priceFeedAddress = tokenPriceFeedMapping[_token]; //now that we have this, we can use it on an AggregatorV3 interface
        AggregatorV3Interface priceFeed = AggregatorV3Interface(
            priceFeedAddress
        );
        (, int256 price, , , ) = priceFeed.latestRoundData();
        uint256 decimals = uint256(priceFeed.decimals());

        return (uint256(price), decimals);
    }

    /*
    ERC20 have two transfer functions, i.e. 
    1. transfer(): used when calling from a wallet/contract that owns the ERC20
    2. transferFrom(): used when calling from a wallet/contract which does not own the ERC20
     */
    function stakeTokens(uint256 _amount, address _token) public {
        require(_amount > 0, "Amount must be more than 0");
        require(tokenIsAllowed(_token), "Token is currently not allowed");
        IERC20(_token).transferFrom(msg.sender, address(this), _amount); //let's wrap this token address as an ERC20 token; so we have the abi via the IERC20 interface; 'msg.sender' means whoever called the function in which it is located, 'address(this)' represents the address to which to send.
        //transferFrom() used because our TokenFarm contract is not the one that owns the ERC20
        updateUniqueTokensStaked(msg.sender, _token); // Update our unique token staked; get a good idea of how many tokens this user has
        stakingBalance[_token][msg.sender] =
            stakingBalance[_token][msg.sender] +
            _amount; //update our staking balance
        if (uniqueTokensStaked[msg.sender] == 1) {
            // if this is their first unique token, we are going to add them to the stakers list
            stakers.push(msg.sender);
        }
    }

    function unstakeTokens(address _token) public {
        uint256 balance = stakingBalance[_token][msg.sender];
        require(balance > 0, "Staking balance cannot be 0");
        IERC20(_token).transfer(msg.sender, balance); //transfer all of the balance
        stakingBalance[_token][msg.sender] = 0; //update how many unique tokens that they have
        uniqueTokensStaked[msg.sender] = uniqueTokensStaked[msg.sender] - 1; //update the list of unique tokens to reflect that one has been token out
    }

    function updateUniqueTokensStaked(address _user, address _token) internal {
        if (stakingBalance[_token][_user] <= 0) {
            uniqueTokensStaked[_user] = uniqueTokensStaked[_user] + 1;
        }
    }

    function addAllowedTokens(address _token) public onlyOwner {
        allowedTokens.push(_token);
    }

    function tokenIsAllowed(address _token) public view returns (bool) {
        for (
            uint256 allowedTokensIndex = 0;
            allowedTokensIndex < allowedTokens.length;
            allowedTokensIndex++
        ) {
            if (allowedTokens[allowedTokensIndex] == _token) {
                return true;
            }
        }
        return false;
    }
}
