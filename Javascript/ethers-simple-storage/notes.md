_QUICK JAVASCRIPT REFRESHER_

```javascript
function main() {
  console.log("hi"); // printing out to console
  let variable = 5; // variable declaration and assignment
  console.log(variable);
}

main();
```

E.g. sychronous programming languages: Solidity
E.g. asychronous programming languages: Javascript

Analogies:

- Synchronous

1. Put popcorn in microwave => a promise
2. Wait for popcorn to finish
3. Pour drinks for every

- Asynchronous

1. Put popcorn in the microwave; while popcorn in microwave, pour drink
2. Wait for popcorn to finish

```javascript
// Asynchronous functions are important because most of the functions that we'll be writing will be waiting for other code of functions to run so if we do not wait, everything will not work as intended
async function setupMovieNight() {
  // keyword "async" makes our function asynchronous, and gives us acces to the keyword "await" which can be used in asynchronous functions
  await cookPopcorn();
  await pourDrinks();
  startMovie();
}
```

\*/

_COMPILING CODE_
for Solidity together with javascript, in order to compile, we need solc-js

/Dependencies/

- npm: node package manager; installed by default if nodejs is installed
- corepack: installed by default if nodejs is installed

```bash
npm i -g solc # To install solc via npm
```

- yarn: an alternative package manager (Preferred by tutorial)

```bash
# To install yarn
corepack enable # newer way
npm i -g corepack # older way; installs yarn globally

corepack --version
```

```bash
yarn add solc@<solidity_verion_used>-fixed # to install solc via yarn (e.g. $yarn add solc@0.8.14-fixed)
yarn init -y # if the package.json file is not created
```

- solc: solidity compiler is now installed using yarn so we can either compile in the deploy.js code file or we can compile directly on the command line using solcjs

```bash
yarn solcjs --help # for help on compilation
yarn solcjs --version # to find the version
yarn solcjs --bin --abi --include-path node_modules/ --base-path . -o . SimpleStorage.sol # to FINALLY COMPILE !!!
```

/Key Actions/
To allow for automatic compilation upon typing 
```bash
yarn compile
```
, add "scripts" directive to my package.json file
```json
"scripts":{
    "compile":"yarn solcjs --bin --abi --include-path node_modules/ --base-path . -o . SimpleStorage.sol"
  }
```
Scripts in json file are a really useful way for us to run very long commands

_DEPLOYMENT_
We previously used two methods in Solidity:
1. Deploying to Javascript/Remix virtual machine (VM) -i.e., a *FAKE BLOCKCHAIN* or
2. Injected Web3 ( via Metamask) to a TESTNET (e.g., Sepolia)

Here in Javascript
1. Our *FAKE BLOCKCHAIN* is GANACHE

- Making API calls to endpoints DIRECTLY by using API endpoints like AXIOS or FETCH
We will use the Ganache RPC endpoint (i.e.,127.0.0.1:7545). Examples of other endponts (You can see using Metamask->Add Network->Networks):
For Sepolia testnet: https://sepolia.infura.io/v3/
For Linea Goerli testnet: https://linea-goerli.infura.io/v3/

- Making API calls using either wrapper/packages Ether.js (preferrable because they are the main tool that power "Hardhead" environment) or Web3.js 


* To install Ethers
```bash
npm install --save ethers # for npm or
yarn add ethers # to be able to connect to blockchain and connect to wallets
yarn add fs-extra # to be able to read ABI and BIN versions of COMPILED files
```

To deploy
```bash
node deploy.js # If we are working with "truffle", we will see our deployed contracts in the "CONTRACTS" pane of ganache but since we are working with "hardhat", we will not see them
```