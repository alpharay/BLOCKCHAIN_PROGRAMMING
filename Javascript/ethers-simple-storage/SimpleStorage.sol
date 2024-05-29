// SPDX-License-Identifier: MIT
//pragma solidity ^0.8.0; // this line enables us to work with any verion of 0.8

pragma solidity >=0.6.12 <0.9.0; // solidity version being useds;

contract SimpleStorage {
    /* PRIMARY TYPES
    uint256 favoriteNumber = 5;
    int256 favoriteInt = -5;
    bool favoriteBool = false;
    string favoriteString = "String";

    address favoriteAddress = 0x13cCB09348f46cF194f59Ea505fd747D3ABd737b;
    bytes32 favoriteByte = "cat";
    */
    uint256 public favoriteNumber; //automatically gets initialized to zero

    /* USER-DEFINED TYPES */
    struct People {
        uint256 favoriteNumber;
        string name;
    }

    People public person = People({favoriteNumber: 2, name: "Patrick"});

    /* ARRAY CREATION */
    //People [2] public people; //ex fixed array
    People[] public people; //dynamic array; more similar to java array declaration than c++
    mapping(string => uint256) public nameToFavoriteNumber;

    /* FUNCTIONS*/
    function store(uint256 _favorite) public {
        favoriteNumber = _favorite;
    }

    function retrieveView() public view returns (uint256) {
        //PC: return type declaration comes at the end of the function declaration in solidity unlike in other programming languages like java and c++
        return favoriteNumber;
    }

    function retrievePure(uint256 favoriteNumber1) public pure {
        favoriteNumber1 + favoriteNumber1;
    }

    function addPerson(string memory _name, uint256 _favoriteNumber) public {
        people.push(People({favoriteNumber: _favoriteNumber, name: _name}));
        nameToFavoriteNumber[_name] = _favoriteNumber;
    }
}
