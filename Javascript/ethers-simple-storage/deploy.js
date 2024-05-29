const ethers = require("ethers"); // this will be "import" instead of "requires" if Typescript is being used. The "const" keyword is similar to "let" but unlike the later, the variable with "const" cannot be changed
const fs = require("fs-extra"); // to be able to read in ABI and BIN files

async function main() {
    const provider = new ethers.JsonRpcProvider ("http://127.0.0.1:7545") // Our connectio to the blockchain
    const wallet = new ethers.Wallet("0x2995de43cedf5163cb67ba62f860b778378b5fa67fa5d302531b6c897075033e", provider); // Our private key with which to sign in to our wallets
    const abi = fs.readFileSync("./SimpleStorage_sol_SimpleStorage.abi", "utf8");
    const binary = fs.readFileSync("./SimpleStorage_sol_SimpleStorage.bin", "utf8");
    const contractFactory = new ethers.ContractFactory(abi,binary,wallet);
    console.log("Deploying, please wait...");
    const contract = await contractFactory.deploy();
    const deploymentReceipt = await contract.deploymentTransaction().wait(1);
    console.log("Here is the deployment transaction (transaction response): ",contract.deploymentTransaction(),"\n");// gives the TRANSACTION RESPONSE; "await keyword" means "STOP here! Wait for contract to deploy"
    console.log("Here is the deployment receipt: ",deploymentReceipt); //gives the TRANSACTION RECEIPT; you only get a transaction receipt when you wait for a block confirmation. Otherwise you'll only get the contract object (i.e., contract.deploymentTransaction() without the receipt - the 'wait()' part)

}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
