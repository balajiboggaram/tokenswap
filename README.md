# tokenswap
A sample example for token swap. 

A new IERC20 token is created in this repo. A reference from openzeppelin is used for demonstration purpose. Reference at : https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol

Problem statement :

There are two types of IERC20 based tokens : 

1. SEATTLE_TOKEN_A
2. SEATTLE_TOKEN_B

Alice is the owner of SEATTLE_TOKEN_A and Bob is the owner of SEATTLE_TOKEN_B. Alice would like to transfer SEATTLE_TOKEN_A to Bob in exchange of SEATTLE_TOKEN_B. I have created a 'TokenSwap' smart contract which acts as intermediary in successful exchange of these tokens as auto swap between these two parties in a single transaction.
