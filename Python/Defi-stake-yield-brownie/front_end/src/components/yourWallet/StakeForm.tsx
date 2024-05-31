import { formatUnits } from "@ethersproject/units";
import { Token } from "../Main";
import { useEthers, useTokenBalance, useNotifications } from "@usedapp/core";
import { Button, CircularProgress, Input, Snackbar } from "@material-ui/core";
import Alert from "@material-ui/lab/Alert";
import React, { useEffect, useState } from "react";
import { useStakeTokens } from "../../hooks";
import { utils } from "ethers";

export interface StakeFormProps {
  token: Token;
}

export const StakeForm = ({ token }: StakeFormProps) => {
  const { address: tokenAddress, name } = token;
  const { account } = useEthers();
  const tokenBalance = useTokenBalance(tokenAddress, account);
  const formattedTokenBalance: number = tokenBalance
    ? parseFloat(formatUnits(tokenBalance, 18))
    : 0;
  const { notifications } = useNotifications();

  const [amount, setAmount] = useState<
    number | string | Array<number | string>
  >(0);
  const handleInputChange = (event: React.ChangeEvent<HTMLInputElement>) => {
    const newAmount =
      event.target.value === "" ? "" : Number(event.target.value); //means that If equal to nothing then nothing else cast event to number
    setAmount(newAmount);
    console.log(newAmount);
  };
  /*we need now to send our amount as part of our "stake". This means
1. calling approve with the newAmount
2. then we have to call from our 'TokenFarm.sol' and specifically the stake method (i.e. the issueTokens method)

To do all that we need to create some new state hooks in the "hooks" folder. Hooks are more like components (i.e.those found in "components" folder)
except that they are more functionality wise

see "hooks/useStakeTokens.ts"
*/

  // our 'state' varible from 'useStakeTokens.ts' gets mapped to 'approveAndStakeErc20State' like so 'state: approveAndStakeErc20State'
  const { approveAndStake, state: approveAndStakeErc20State } =
    useStakeTokens(tokenAddress); //GETTING THE RETURNED VALUE FROM THE useStakeTokens.ts HOOK (i.e. approveAndStake 'hooking function')

  const handleStakeSubmit = () => {
    const amountAsWei = utils.parseEther(amount.toString()); //convert amount from string to Wei
    return approveAndStake(amountAsWei.toString());
  };

  const handleCloseSnack = () => {
    setShowERrc20ApprovalSuccess(false);
    setShowStakeTokenSuccess(false);
  };

  // PNB: APPROVE STATE tracking switch: to cause something like a rotating circle to show up when in a 'waiting' state on our browsing and whiles waiting for 'approve' to take effect
  const isMining = approveAndStakeErc20State.status === "Mining";

  // PNB: to create a variable to track when it has been actually approved/staked
  const [showErc20ApprovedSuccess, setShowERrc20ApprovalSuccess] =
    useState(false);
  const [showStakeTokenSuccess, setShowStakeTokenSuccess] = useState(false);

  //PNB: putting in some notifications based on useEffect
  useEffect(() => {
    if (
      notifications.filter(
        (notification) =>
          notification.type === "transactionSucceed" &&
          notification.transactionName === "Approve ERC20 transfer"
      ).length > 0
    ) {
      setShowERrc20ApprovalSuccess(true);
      setShowStakeTokenSuccess(false);
      console.log("Approved!");
    }
    if (
      notifications.filter(
        (notification) =>
          notification.type === "transactionSucceed" &&
          notification.transactionName === "Stake Tokens"
      ).length > 0
    ) {
      setShowERrc20ApprovalSuccess(false);
      setShowStakeTokenSuccess(true);
      console.log("Tokens Staked");
    }
  }, [notifications, showErc20ApprovedSuccess, showStakeTokenSuccess]); // if anything in our metamask (i.e. notifications) changes, we want to do something

  // SHOWING RESULTS ON PAGE
  return (
    <>
      <div>
        <Input onChange={handleInputChange} />
        <Button
          onClick={handleStakeSubmit}
          color="primary"
          size="large"
          disabled={isMining}
        >
          {isMining ? <CircularProgress size={26} /> : "Stake!!!"}
        </Button>
      </div>
      {/* One snackbar is for ERC-20 */}
      <Snackbar
        open={showErc20ApprovedSuccess}
        autoHideDuration={5000}
        onClose={handleCloseSnack}
      >
        <Alert onClose={handleCloseSnack} severity="success">
          ERC-20 token approved! Now approve the 2nd transaction.
        </Alert>
      </Snackbar>
      {/* Another snackbar for token staked */}
      <Snackbar
        open={showStakeTokenSuccess}
        autoHideDuration={5000}
        onClose={handleCloseSnack}
      >
        <Alert onClose={handleCloseSnack} severity="success">
          Token Staked.
        </Alert>
      </Snackbar>
    </>
  );
};
