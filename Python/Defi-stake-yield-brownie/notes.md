#+AUTHOR: KB
#+PURPOSE: Notes on some key things learned. Also on problems encountered and how debugging was done
#+LINKS: [[https://docs.infura.io/api/networks/ethereum/quickstart][Quickstart]]
#+VIDEO LINK:[[https://www.youtube.com/watch?v=DMbUJ_du37M][Rapid DApp Development with useDApp]]
#+RELATED FILE(S): 11:22:38: "PROGRAMMING_WORLD/BLOCKCHAIN_PROGRAMMING/Python/Web3_py_simple_storage/deploy_on_sepolia.py"

_PROBLEMS AND BUGS ENCOUNTERED AND HOW THEY WERE SOLVED_

- CONFIGURATION PROBLEM READING FROM INFURA via SEPOLIA TESTNET

\*\* SOLUTION

1. Make sure you have an infura account and have created a related API Key
2. In the active endpoint tab, you'll find the active endpoint related to your particular testnet (sepolia in my case). E.g https://sepolia.infura.io/v3/<YOUR-API-KEY>
3. The connection can be testing in the terminal as so

```bash
curl https://mainnet.infura.io/v3/YOUR-API-KEY \
    -X POST \
    -H "Content-Type: application/json" \
    -d '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}'
```

4. Afterwards the link was used in my 'App.tsx' file as so

```tsx
const config: Config = {
  networks: [Sepolia],
  readOnlyUrls: {
    [ChainId.Sepolia]:
      "https://sepolia.infura.io/v3/318c2edb27004a5782f068547cbd370e", //PNB: this is what finally worked.
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
```

\*\*

- TESTING PROBLEMS
  Make sure Ganache is running and on the correct port (preferrable 8545) when you test the application in the browser
- yarn start should always be run from the "front_end" folder
- Run "brownie run script/update_front_end" to update the front end after adding in new contracts to the "contracts" folder if the "script/deploy.py" file does not effect the changes.

_GENERAL NOTES_
Example of defining a function and passing it as a parameter in TypeScript.

```tsx
//The syntax '() => {}' represents function definition in typescript.

// It can be be made into a function with a name as
const my_Effect_function = (param1: string, param2: string) => {
  //do something in here
};

//it could then be called in another function as so
useEffect(my_Effect_function);
```

Alternatively, we can define a function and passing it as a parameter at the same time as so

```tsx
useEffect(() => {});
```

In checking for conditionals in TypeScript '==' is different from '==='. Whereas the
former does type coercing (tries to implicitly convert the operands being compared to the same type) before doing the comparison, the latter does not. The latter checks for
both the similarity in the type AND value. So '==' can return true if the types are different but '===' will always return false

To understand main interractions on the front end, two files to read together are 'useStakeTokens.ts' and 'StakeForm.tsx'

Go to 'front_end/index.css' to make your application appear more beautiful

The useStyles variable through 'makeStyles' method is being used to add css to our tsx files as so

```tsx
const useStyles = makeStyles((theme) => ({
  title: {
    color: theme.palette.common.white,
    textAlign: "center",
    padding: theme.spacing(4),
  },
}));
```

it is then instantiated for calling like so

```tsx
const classes = useStyles();
```
