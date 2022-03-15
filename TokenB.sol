pragma solidity ^0.8.10;

import "./ERC20.sol";

contract TokenB is ERC20 {

    // When deploying, pass the below params to constructor
    // name -> "Token B Contract"
    // symbol -> "SEATTLE_TOKEN_B"
    constructor(string memory name, string memory symbol) ERC20(name, symbol) {
        mint(1000 * 10 ** uint(decimals));
    }

}