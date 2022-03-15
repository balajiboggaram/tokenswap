pragma solidity ^0.8.10;

import "./IERC20.sol";

// Implementation of IERC20 interface.
contract ERC20 is IERC20 {

    string public name;
    string public symbol;
    uint public decimals = 18;

    uint public totalSupply;
    mapping(address => uint ) public balanceOf;
    mapping(address => mapping (address => uint)) public allowance;

    constructor(string memory tokenName, string memory tokenSymbol) {
        name = tokenName;
        symbol = tokenSymbol;
    }
    
    // Direct Transfer function,  OWNER -----(amount)--> RECIPIENT
    function transfer(address recipient, uint amount) external returns (bool) {
        balanceOf[msg.sender] -= amount;
        balanceOf[recipient] += amount;
        emit Transfer(msg.sender, recipient, amount);
        return true;
    }

    // Permit a spender to spend amount from owner, Permission for delegation.
    function approve(address spender, uint amount) external returns (bool) {
        allowance[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    // Delegated Transfer : Send money 'from' to 'to' by 'spender' i.e msg.sender
    function transferFrom(address from, address to, uint amount) external returns (bool) {
        allowance[from][msg.sender] -= amount;
        balanceOf[from] -= amount;
        balanceOf[to] += amount;
        emit Transfer(from, to, amount);
        return true;  
    }

    // Initially get called when token contract is getting deployed.
    function mint(uint amount) public {
        balanceOf[msg.sender] += amount;
        totalSupply += amount;
        emit Transfer(address(0), msg.sender, amount);
    }

    function burn(uint amount) external {
        balanceOf[msg.sender] -= amount;
        totalSupply -= amount;
        emit Transfer(msg.sender, address(0), amount);
    }

}

