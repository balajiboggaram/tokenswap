pragma solidity ^0.8.10;

import "./ERC20.sol";

contract TokenA is ERC20 {

    // When deploying, pass the below params to constructor
    // name -> "Token A Contract"
    // symbol -> "SEATTLE_TOKEN_A"
    constructor(string memory name, string memory symbol) ERC20(name, symbol) {
        mint(1000 * 10 ** uint(decimals));
    }

}