import { Token } from "../Main";
import React, { useState } from "react";
import { Box, makeStyles } from "@material-ui/core";
import { TabContext, TabList, TabPanel } from "@material-ui/lab";
import { Tab } from "@material-ui/core";
import { WalletBalance } from "./WalletBalance";
import { StakeForm } from "./StakeForm";

//To tell typescript what the supported token is going to look like
interface YourWalletProps {
  supportedTokens: Array<Token>;
}

const useStyles = makeStyles((theme) => ({
  tabContent: {
    display: "flex",
    flexDirection: "column",
    alignItems: "center",
    gap: theme.spacing(4),
  },
  box: {
    backgroundColor: "white",
    borderRadius: "25px",
  },
  header: {
    color: "white",
  },
}));

export const YourWallet = ({ supportedTokens }: YourWalletProps) => {
  const [selectedTokenIndex, setSelectedTokenIndex] = useState<number>(0); //creates a 'selectedTokenIndex' variable to give us which token we are currently. This is updated with 'setSelectedTokenIndex'. 'useState' gives us a way of saving state between different rendered components

  const handleChange = (event: React.ChangeEvent<{}>, newValue: string) => {
    setSelectedTokenIndex(parseInt(newValue)); //for working with the onChange to change the selected token anytime we change the tab
  };

  const classes = useStyles();
  return (
    <Box>
      <h1 className={classes.header}> Your Wallet! </h1>
      <Box className={classes.box}>
        <TabContext value={selectedTokenIndex.toString()}>
          <TabList onChange={handleChange} arial-label="stake form tabs">
            {supportedTokens.map((token, index) => {
              return (
                <Tab label={token.name} value={index.toString()} key={index} />
              );
            })}
          </TabList>
          {supportedTokens.map((token, index) => {
            return (
              <TabPanel value={index.toString()} key={index}>
                <div className={classes.tabContent}>
                  <WalletBalance token={supportedTokens[selectedTokenIndex]} />
                  <StakeForm token={supportedTokens[selectedTokenIndex]} />
                </div>
              </TabPanel>
            );
          })}
        </TabContext>
      </Box>
    </Box>
  );
};
