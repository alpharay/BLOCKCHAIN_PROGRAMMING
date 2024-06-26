import { Web3 } from 'web3';

// Set up a connection to the Ganache network
const web3 = new Web3(new Web3.providers.HttpProvider('http://localhost:7545'));

// Log the current block number to the console
web3.eth
    .getBlockNumber()
    .then((result) => {
        console.log('Current block number: ' + result);
    })
    .catch((error) => {
        console.error(error);
    });