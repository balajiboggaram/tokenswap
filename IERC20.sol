pragma solidity ^0.8.10;

// Reference from : https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol

interface IERC20 {

     //  Returns the amount of tokens in existence.
    function totalSupply() external view returns (uint256);

     //  Returns the amount of tokens owned by `account`.
    function balanceOf(address account) external view returns (uint256);

    // Direct Transfer : Moves `amount` tokens from the caller's account to `to`.
    function transfer(address to, uint256 amount) external returns (bool);

    // Returns the remaining amount of tokens a spender can spend on behalf of ownwer
    function allowance(address owner, address spender) external view returns (uint256);

    // Allow a spender to spend amount on behalf of owner (caller of this fuction)
    function approve(address spender, uint256 amount) external returns (bool);

    // Indirect Transfer : Move the 'amount' 'from' address to 'to' address 
    function transferFrom(address from, address to, uint256 amount) external returns (bool);

    // emit a event upon transfer is done
    event Transfer(address indexed from, address indexed to, uint256 value);

    // emit an event upon approval is called
    event Approval(address indexed owner, address indexed spender, uint256 value);
}