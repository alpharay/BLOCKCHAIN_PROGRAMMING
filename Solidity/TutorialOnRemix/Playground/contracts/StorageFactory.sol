// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/* IMPORTING */
import "./SimpleStorage.sol";


contract StorageFactory{
    SimpleStorage [] public simpleStorageArray;

    function createSimpleStorageContract() public {//to deploy 'SimpleStorage' Contract
    SimpleStorage simpleStorage = new SimpleStorage();
    simpleStorageArray.push(simpleStorage);
    }

    function sfStore(uint256 _simpleStorageIndex, uint256 _simpleStorageNumber) public{//for calling function using the address of one of the simpleStorage contracts stored on the SimpleStorageFactory to store a number onto that contract
    SimpleStorage simpleStorage = SimpleStorage(address(simpleStorageArray[_simpleStorageIndex]));
    simpleStorage.store(_simpleStorageNumber);
    }
}