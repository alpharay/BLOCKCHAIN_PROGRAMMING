//this is where we are going to be reading off chain after a lot of typescript and react setup
import { useEthers, useTokenBalance } from "@usedapp/core";
//import { useTokenBalance, useContract } from "@thirdweb-dev/react";
import { Token } from "../Main";
import { formatUnits } from "@ethersproject/units";
//import { BalanceMsg } from "../../components/BalanceMsg";
import { BalanceMsg } from "../BalanceMsg"; //PNB: I changed the line above because it seemed unnecessary to go two directories up

import brownieConfig from "../../brownie-config.json";

export interface WalletBalanceProps {
  token: Token;
}

//since we are going to be importing into our 'yourWallet; component, we want to do
export const WalletBalance = ({ token }: WalletBalanceProps) => {
  const { image, address, name } = token;

  const { account } = useEthers(); // to get the address of the account
  const tokenBalance = useTokenBalance(address, account); // a nice hook by useTokenBalance that is provided by usedapp

  const formattedTokenBalance: number = tokenBalance
    ? parseFloat(formatUnits(tokenBalance, 18))
    : 0;

  //const privateKey = brownieConfig["wallets"]["from_key"];
  const privateKey =
    brownieConfig["other_networks"]["infura"]["WEB3_INFURA_PROJECT_ID"];

  console.log(tokenBalance?.toString());
  console.log(address);
  console.log(account);
  console.log(privateKey);
  return (
    <BalanceMsg
      label={`Your un-staked ${name} balance`}
      tokenImgSrc={image}
      amount={formattedTokenBalance}
    />
  ); //Do a return so that it is actually a JSX component
};
