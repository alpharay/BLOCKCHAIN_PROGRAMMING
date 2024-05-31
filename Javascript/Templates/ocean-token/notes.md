#+Author:
#+Purpose: To implement the steps needed in token Design (i.o.w create your own token)

_NOTES_

- steps

1. Initial supply (send to owner) - 70,000,000 [DONE]
2. max supply (capped) - 100,000,000; If you are not sure as to how high to set the max supply, it is alays better to err on the side of too high as you can always burn tokens later, but you cannot always add them [DONE]
3. Make token burnable; Maybe later, we will decide that the maximum number of tokens that we set was too high and as such may want the ability to burn the extra. - [DONE]
4. Creat a block reward to distribute new supply to miners

4.1 variable: blockReward
4.2 function: \_beforeTokenTransfer()
4.3 function: \_mintMinerReward()

_INSTALLATIONS_

_COMMANDS_
