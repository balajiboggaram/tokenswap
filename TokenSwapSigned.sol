pragma solidity ^0.8.10;

import "./IERC20.sol";

contract TokenSwapSigned {

    IERC20 public tokenA; // SEATTLE_TOKEN_A
    IERC20 public tokenB; // SEATTLE_TOKEN_B
    address public alice;
    address public bob;
    mapping(uint256 => bool) aliceNonces; // Nonces picked by Alice, when sending message to Bob.
    mapping(uint256 => bool) bobNonces; // Nonces picked by Bob, when sending message to Alice.

    constructor(address _tokenA, address _aliceAddress, address _tokenB, address _bobAddress) {
        tokenA = IERC20(_tokenA);
        tokenB = IERC20(_tokenB);
        alice = _aliceAddress;
        bob = _bobAddress;
    }
    
    /* 
     * 
     Scenario #1 : Alice encrypts message and sends to Bob(via email etc). Bob calls this swap function to initiate the swap transaction. The transaction performs 
                  two transfers. i.e 1. Send TokenA to Alice and  2. Send TokenB to Bob.

     Scenario #2 : Bob encrypts a message and sends to Alice(via email etc). Alice calls this swap function to initiate the swap transaction. The transaction performs 
                 two transfers. i.e 1. Send TokenB to Alice and 2. Send TokenA to Bob

     * Returns true : If the atomic swap is successful, false : On failure.
     *
     * Requirements : 
     * - 'msg.sender' should be either alice or bob.
     * - tokenA_Amount should be approved by Alice.
     * - tokenB_Amount should be approved by Bob.
     */
    function swap(uint tokenA_Amount, uint tokenB_Amount, uint256 nonce, bytes memory sig) public  {

        // Bob will claim for the payment
        require(msg.sender == bob || msg.sender == alice, "401 Unauthorized");

        // Alice has to authorize the required amount to swap contract
        require(tokenA.allowance(alice, address(this)) >= tokenA_Amount, "Alice has not authorized the required balance");
        
        // Bob has to authorize the required amount to swap contract
        require(tokenB.allowance(bob, address(this)) >= tokenB_Amount, "Bob has not authorized the requied balance");

        // Re-compute the messageHash
        uint amount = msg.sender == alice ? tokenA_Amount : tokenB_Amount;
        bytes32 message  = prefixed(keccak256(abi.encodePacked(msg.sender, amount, nonce, address(this))));

        // Validate nonce and Signer of the message
        if (msg.sender == alice) {
            validateNonce(aliceNonces, nonce); // prevent replay attacks
            require(recoverSigner(message, sig) == bob); // Bob should have signed this message.
        } else {
            validateNonce(bobNonces, nonce);
            require(recoverSigner(message, sig) == alice); // Alice should have signed this message.
        }

        transferAmount(tokenA, alice, bob, tokenA_Amount); // Alice -> Bob (TokenA amount)
        transferAmount(tokenB, bob, alice, tokenB_Amount); // Bob -> Alice (TokenB amount)
    }

    // Fetch the address of the actual signer of the message
    function recoverSigner(bytes32 msgHash, bytes memory signature) internal pure returns (address) {
        uint8 v;
        bytes32 r;
        bytes32 s;

        (v, r, s)= splitSignature(signature);
        return ecrecover(msgHash, v, r, s);
    }

    // Split the signature and extracts the v, r and s
    function splitSignature(bytes memory signature) internal pure returns (uint8, bytes32, bytes32) {
        require (signature.length == 65);

        bytes32 r;
        bytes32 s;
        uint8 v;

        assembly {
             // Extract first 32 bytes, after the length prefix
            r := mload(add(signature, 32))
             // Extract second 32 bytes
            s := mload(add(signature, 64))
            // Final byte
            v := byte(0,mload(add(signature, 96)))
        }

        return (v,r,s);
    }

     // Builds a prefixed hash to mimic the behavior of eth_sign.
    function prefixed(bytes32 hash) internal pure returns (bytes32) {
        return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
    }

    function validateNonce(mapping(uint256 => bool) storage nonces, uint256 nonce) internal {
        require(!nonces[nonce]);
        nonces[nonce] = true;
    }

    function transferAmount(IERC20 token, address sender, address recipient, uint amount) private {
        bool transferStatus = token.transferFrom(sender, recipient, amount);
        require(transferStatus, "Transfer failed");
    }
}