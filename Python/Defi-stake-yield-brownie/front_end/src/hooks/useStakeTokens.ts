import { useContractFunction, useEthers } from "@usedapp/core"

import TokenFarm from "../chain-info/contracts/TokenFarm.json"// to be able to call chainId below
import ERC20 from "../chain-info/contracts/MockERC20.json"

import networkMapping from "../chain-info/deployments/map.json"
import { constants, utils } from "ethers"
import { Contract } from "@ethersproject/contracts"
import { useEffect, useState } from "react"


export const useStakeTokens = (tokenAddress: string) => {
    /* What will be needed?
    1. Address call
    2. Abi
    3. ChainId
    */

    const { chainId } = useEthers()
    const { abi } = TokenFarm
    //const dappTokenAddress = chainId ? networkMapping[String(chainId)]["DappToken"][0] : constants.AddressZero; //copied from Main.tsx
    const tokenFarmAddress = chainId ? networkMapping[String(chainId)]["TokenFarm"][0] : constants.AddressZero

    // GOAL: to get TWO MAIN CONTRACTS NEEDED: 1. TokenFarmContract 2. erc20Contract

    //To be able to interact with this 'tokenFarmAddress' contract, we have to create an interface
    const tokenFarmInterface = new utils.Interface(abi)
    // Now having the interface, we will create a contract
    const tokenFarmContract = new Contract(tokenFarmAddress, tokenFarmInterface)

    /* Having gotten the contract from the above, now we can call some functions.
    What actions will be carried out?
    1. approve => we have to get token contract (i.e. ERC20 token contract) first before we work with the stake token
    2. stake tokens
    */

    // 1. APPROVE STAGE:
    const erc20ABI = ERC20.abi
    const erc20Interface = new utils.Interface(erc20ABI)
    const erc20Contract = new Contract(tokenAddress, erc20Interface)

    /*
    useContractFunction is a hook that returns an object with two variables
    (i.e. send & state). In working, 'useContractFunction' is called on our
    'erc20Contract' which in turn is made to call its "approve" method by linking/hooking
    it here into the 'approveErc20Send' variable which is the used as a what I'll call a
    'hooking function' here to call back the "approve" function by giving it exactly
    the variables it needs (i.e. address spender AND uint256 amount)
    */
    const { send: approveErc20Send, state: approveAndStakeErc20State } = useContractFunction(erc20Contract, "approve", { transactionName: "Approve ERC20 transfer", }) //useContractFunction is a hook that returns an object with two variables (i.e. send & state). 'useContractFunction' is called on our 'erc20Contract' which in turn is made to call its "approve" method by returning it here into the 'approveErc20Send' variable which is the used as a function here to call back the approve function by giving it exactly the variables it needs

    const approveAndStake = (amount: string) => {
        setAmountToStake(amount)
        return approveErc20Send(tokenFarmAddress, amount)//PNB: remember to enter the right parameters here otherwise it will lead to a bug
    }

    // 2. STAKING STAGE

    /*
    useContractFunction is a hook that returns an object with two variables (i.e. 
    send & state). In working, 'useContractFunction' is called on our
    'tokenFarmContract' which in turn is made to call its "stakeTokens" method by linking/hooking
    it here into the 'stakeSend' variable which is the used as a what I'll call a
    'hooking function' here to call back the "stakeTokens" function by giving it exactly
    the variables it needs (i.e. uint256 _amount AND address _token)
    */
    const { send: stakeSend, state: stakeState } = useContractFunction(tokenFarmContract, "stakeTokens", { transactionName: "Stake Tokens" })
    const [amountToStake, setAmountToStake] = useState("0")

    //useEffect: allows us to do something if a variable has changed. It take a function as an input
    useEffect(() => {
        if (approveAndStakeErc20State.status === "Success") {// PNB: not the "===" instead of "=="
            //State function
            stakeSend(amountToStake, tokenAddress)// this matches to the 'stakeTokens()' functions in our 'TokenFarm.sol' contract
        }

    }, [approveAndStakeErc20State, tokenAddress])//the second parameter into useEffect is an 'watching' list of things we want to track to see when they chang e and to have the function defined into the parameter called as a result


    const [state, setState] = useState(approveAndStakeErc20State)
    useEffect(() => {
        if (approveAndStakeErc20State.status === "Success") {
            setState(stakeState)
        } else {
            setState(approveAndStakeErc20State)
        }

    }, [approveAndStakeErc20State, stakeState])

    return { approveAndStake, state }


}