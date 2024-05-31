# LINK: [[https://www.youtube.com/watch?v=gyMwXuJrbJQ&t=30017s][Learn Blockchain, Solidity, and Full Stack Web3 Development with JavaScript – 32-Hour Course]]

- To initialize the project file (i.e. sets up the 'package.json' file for us)

```bash
npm init # if using npm OR
yarn init # if using yarn (which we prefer)
```

- To create the 'yarn.lock' file

```bash
yarn add --dev hardhat
```

- To create and initialize hardhat project

```bash
yarn hardhat
```

- To install prettier package in development environment and provide prettier formatter configuration file

```bash
yarn add --dev --prettier prettier-plugin-solidity
```

_GENERAL NOTES_

- the '@' symbol in front of some packages in the 'node_modules' folder helps denote those packages as 'scoped packages' (i.e. namespaced); it also helps us know which team published the package (e.g. '@nomicfoundation' means it is built by the team at 'nomicfoundation')
- hardhat.config.js file can be thought of as the entry point to all the scripts that we'll be writing. It is the configuration file that determines how the rest of the code we have written is going to interract with the rest of the blockchain.

_TROUBLESHOOTING_

- Yarn initialization not working

* When your run

```bash
yarn hardhat
```

but to not get a menu of options to create your hardhat project => You have a config file somewhere it shouldn't be and therefore have to delete it. What's the solution? Run

```bash
npx hardhat --verbose
```

it will show you were the config file is so that you can delete it.

- Forgetting to npm install
  When working with a repo which someone else has been working on, you should run 'npm install' to get the packages that were installed for that specific project also installed on yours.
