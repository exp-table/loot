// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {ERC20} from "solady/tokens/ERC20.sol";
import {MerkleProofLib} from "solady/utils/MerkleProofLib.sol";
import {LibBitmap} from "solady/utils/LibBitmap.sol";

contract SnapSomething {
    using LibBitmap for LibBitmap.Bitmap;


    /*###############################################################
                            EVENTS
    ###############################################################*/

    event Claimed(address indexed user, uint256 index, uint256 amount);


    /*###############################################################
                            STORAGE
    ###############################################################*/

    ERC20 public token;
    bytes32 public merkleRoot;
    address public owner;

    LibBitmap.Bitmap internal claims;

    modifier onlyOwner() virtual {
        require(msg.sender == owner, "UNAUTHORIZED");
        _;
    }

    /*###############################################################
                            INITIALIZATION
    ###############################################################*/

    function initialize(address _token, bytes32 _merkleRoot) external {
        require(address(token) == address(0), "ALREADY_INITIALIZED");
        token = ERC20(_token);
        merkleRoot = _merkleRoot;
        owner = msg.sender;
    }

    /*###############################################################
                            OWNER LOGIC
    ###############################################################*/

    function setMerkleRoot(bytes32 _merkleRoot) external onlyOwner {
        merkleRoot = _merkleRoot;
    }

    function withdrawTokens(address _token) external onlyOwner {
        ERC20(_token).transfer(msg.sender, ERC20(_token).balanceOf(address(this)));
    }

    /*###############################################################
                            USER LOGIC
    ###############################################################*/

    /**
     * @notice amount is not scaled by token's decimals
     */
    function claim(address _user, uint256 _index, uint256 _amount, bytes32[] calldata _proof) external {
        require(!claims.get(_index), "ALREADY_CLAIMED");
        bytes32 node = keccak256(abi.encodePacked(_index, _user, _amount));
        require(MerkleProofLib.verify(_proof, merkleRoot, node), "INVALID_PROOF");
        claims.set(_index);
        uint256 scaledAmount = _amount * (10**token.decimals());
        token.transfer(_user, scaledAmount);
        emit Claimed(_user, _index, scaledAmount);
    }

    function claimed(uint256 _index) public view returns (bool) {
        return claims.get(_index);
    }
}
