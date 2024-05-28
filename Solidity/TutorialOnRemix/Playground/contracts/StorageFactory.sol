// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/* IMPORTING */
import "./SimpleStorage.sol";


contract StorageFactory is SimpleStorage{ 
    /* We can make 'SimpleStorageFactory' inherit from 'SimpleStorage.sol' by using 'is' keyword. 
    By that not only will it be just able to use the function/methods from 'SimpleStorage' but 
    also it will be a 'SimpleStorage' class on it on and as such have all the base functions appearing in its deployment pane.*/
    SimpleStorage [] public simpleStorageArray;

    function createSimpleStorageContract() public {//to deploy 'SimpleStorage' Contract
    SimpleStorage simpleStorage = new SimpleStorage();
    simpleStorageArray.push(simpleStorage);//PNB: In a way, this is a static array used to store objects of 'SimpleStorage' class
    }

    function sfStore(uint256 _simpleStorageIndex, uint256 _simpleStorageNumber) public{//for calling function using the address of one of the simpleStorage contracts stored on the SimpleStorageFactory to store a number onto that contract
    /*SimpleStorage simpleStorage = SimpleStorage(address(simpleStorageArray[_simpleStorageIndex]));
    simpleStorage.store(_simpleStorageNumber);*/
    SimpleStorage(address(simpleStorageArray[_simpleStorageIndex])).store(_simpleStorageNumber);//this does the same as the preceeding two lines
    }

    function sfGet(uint256 _simpleStorageIndex) public view returns (uint256){//since we are only going to reading state, this is going to be a "public view" function
    /*SimpleStorage simpleStorage = SimpleStorage(address(simpleStorageArray[_simpleStorageIndex]));
    return simpleStorage.retrieveView();*/
    return SimpleStorage(address(simpleStorageArray[_simpleStorageIndex])).retrieveView();//this does the same as the preceeding two lines
    }
}