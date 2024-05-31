import React from "react";
import { DAppProvider, Config, Sepolia, ChainId } from "@usedapp/core";
//import { DAppProvider, Sepolia } from "@usedapp/core";
import { Header } from "./components/Header";
import { Container } from "@material-ui/core";
import { Main } from "./components/Main";
//import { getDefaultProvider } from "ethers";
import brownieConfig from "./brownie-config.json";

//const privateKey = brownieConfig["wallets"]["from_key"];
const WEB_INFURA_ID =
  brownieConfig["other_networks"]["infura"]["WEB3_INFURA_PROJECT_ID"];

const config: Config = {
  networks: [Sepolia],
  readOnlyUrls: {
    ///[Sepolia.chainId]: getDefaultProvider("sepolia"),
    //[ChainId.Sepolia]: "http://localhost:8545",
    [ChainId.Sepolia]:
      //"https://sepolia.infura.io/v3/318c2edb27004a5782f068547cbd370e", //this is what finally worked. For more notes, see 'notes.md' file. Later, try to make this line better by reading the API key from the .env file later and note hard code it in here
      `https://sepolia.infura.io/v3/${WEB_INFURA_ID}`, //this is what finally worked. For more notes, see 'notes.md' file. Later, try to make this line better by reading the API key from the .env file later and note hard code it in here
  },
  notifications: {
    //checking the blockchain every second; remember to import useNotification in StakeForm.tsx as a result
    expirationPeriod: 1000, //this represents 1000 ms
    checkInterval: 1000, //this represents 1000 ms
  },
};
function App() {
  return (
    <DAppProvider config={config}>
      <Header />
      <Container maxWidth="md">
        <Main />
      </Container>
    </DAppProvider>
  );
}
//--- console.log DEBUGGING ---
//console.log(Sepolia.chainId);
//console.log(helperConfig);
// console.log(networkName)

export default App;
