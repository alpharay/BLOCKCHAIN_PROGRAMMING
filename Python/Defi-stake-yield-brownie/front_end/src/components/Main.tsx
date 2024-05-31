/* eslint-disable spaced-comment */ //PNB:Turning off parts of eslint. Eslint is a static code analyzer built into most text editors to help find bugs quickly. It can be run as part of continuous integration
/// <reference types="react-scripts" />
//import {useEthers} from "@usedapp/core"
import { ChainId } from "@usedapp/core";
import helperConfig from "../helper-config.json";
import networkMapping from "../chain-info/deployments/map.json";
import { constants } from "ethers";
import brownieConfig from "../brownie-config.json";
import dapp from "../dapp.png";
import eth from "../eth.png";
import dai from "../dai.png";
import { YourWallet } from "./yourWallet/YourWallet";
import { makeStyles } from "@material-ui/core";

export type Token = {
  image: string;
  address: string;
  name: string;
};

const useStyles = makeStyles((theme) => ({
  title: {
    color: theme.palette.common.white,
    textAlign: "center",
    padding: theme.spacing(4),
  },
}));

export const Main = () => {
  const classes = useStyles(); // applying css styles

  // --- SHOW TOKEN VALUES FROM THE WALLET ---
  // --- GET THE ADDRESS OF THE DIFFERENT TOKENS ---
  // --- GET THE BALANCE OF THE USERS WALLETS ---

  // --- MAKE SURE TO SEND THE 'brownie-config' file and the 'build' folder CREATED WHILE WORKING IN BROWNIE TO OUR 'front_end' folder as json files
  // const {chainId,error} = useEthers()
  // const networkName = chainId ? helperConfig[chainId] : "dev"
  const chainId = ChainId.Sepolia; // useEthers() was not working so I switched to this
  const networkName = chainId ? helperConfig[ChainId.Sepolia] : "dev";

  const privateKey = chainId
    ? brownieConfig["wallets"]["from_key"]
    : constants.AddressZero; // We will grab this also instead from brownie config

  const dappTokenAddress = chainId
    ? networkMapping[String(chainId)]["DappToken"][0]
    : constants.AddressZero;
  const wethTokenAddress = chainId
    ? brownieConfig["networks"][networkName]["weth_token"]
    : constants.AddressZero; // We will grab this instead from brownie config
  const fauTokenAddress = chainId
    ? brownieConfig["networks"][networkName]["fau_token"]
    : constants.AddressZero; // We will grab this also instead from brownie config

  const supportedTokens: Array<Token> = [
    {
      image: dapp,
      address: dappTokenAddress,
      name: "DAPP",
    },
    {
      image: eth,
      address: wethTokenAddress,
      name: "WETH",
    },
    {
      image: dai,
      address: fauTokenAddress,
      name: "DAI",
    },
  ];

  //--- console.log DEBUGGING ---
  //console.log(chainId);
  // console.log(helperConfig)
  // console.log(networkName)
  console.log(privateKey);

  //const dappTokenAddress
  return (
    <>
      <h2 className={classes.title}>Dapp Token App</h2>
      <YourWallet supportedTokens={supportedTokens} />
    </>
  ); //whenever we use components, we have to return some html so that we can use them in our 'App.tsx'
};
