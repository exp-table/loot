// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {ERC20} from "solady/tokens/ERC20.sol";

contract ERC20Mock is ERC20 {

    function name() public view override returns (string memory) {
        return "Mock";
    }

    function symbol() public view override returns (string memory) {
        return "MOCK";
    }

    function mint(address to, uint256 amount) public {
        _mint(to, amount);
    }
}