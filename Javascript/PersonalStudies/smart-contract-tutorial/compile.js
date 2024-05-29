// This code will compile smart contract and generate its ABI and bytecode
// Alternatively, you can use something like `npm i solc && npx solcjs MyContract.sol --bin --abi`

import solc from 'solc';
import path from 'path';
import fs from 'fs';

const fileName: string = 'MyContract.sol';
const contractName: string = 'MyContract';

// Read the Solidity source code from the file system
const contractPath: string = path.join(__dirname, fileName);
const sourceCode: string = fs.readFileSync(contractPath, 'utf8');

// solc compiler config
const input = {
    language: 'Solidity',
    sources: {
        [fileName]: {
            content: sourceCode,
        },
    },
    settings: {
        outputSelection: {
            '*': {
                '*': ['*'],
            },
        },
    },
};

// Compile the Solidity code using solc
const compiledCode = JSON.parse(solc.compile(JSON.stringify(input)));

// Get the bytecode from the compiled contract
const bytecode: string = compiledCode.contracts[fileName][contractName].evm.bytecode.object;

// Write the bytecode to a new file
const bytecodePath: string = path.join(__dirname, 'MyContractBytecode.bin');
fs.writeFileSync(bytecodePath, bytecode);

// Log the compiled contract code to the console
console.log('Contract Bytecode:\n', bytecode);

// Get the ABI from the compiled contract
const abi: any[] = compiledCode.contracts[fileName][contractName].abi;

// Write the Contract ABI to a new file
const abiPath: string = path.join(__dirname, 'MyContractAbi.json');
fs.writeFileSync(abiPath, JSON.stringify(abi, null, '\t'));

// Log the Contract ABI to the console
console.log('Contract ABI:\n', abi);