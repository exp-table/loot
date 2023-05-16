// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "forge-std/Test.sol";

import {ERC20} from "solady/tokens/ERC20.sol";

import {Clones} from "src/Clones.sol";
import {SpoilsOfWar} from "src/SpoilsOfWar.sol";

import {ERC20Mock} from "./ERC20Mock.sol";

import "forge-std/console.sol";

contract SpoilsOfWarTest is Test {
    Clones clones;
    SpoilsOfWar spoilsLogic; // logic
    ERC20Mock token;

    bytes32 merkleRoot = 0x687c53cf87cb252c2f54d050124e20b74693858819fad621a423bb27038e8702;

    function setUp() external {
        clones = new Clones();
        spoilsLogic = new SpoilsOfWar();
        token = new ERC20Mock();
        token.mint(address(this), type(uint256).max);
    }

    function testInitialization() external {
        SpoilsOfWar clone = SpoilsOfWar(clones.clone(address(spoilsLogic)));
        // initialize the clone
        clone.initialize(address(token), merkleRoot);
        // check that the clone is initialized
        assertEq(address(clone.token()), address(token));
        assertEq(clone.merkleRoot(), merkleRoot);
        assertEq(clone.owner(), address(this));

        // cannot re-initialize
        vm.expectRevert();
        clone.initialize(address(token), merkleRoot);
    }

    function testClaim() external {
        SpoilsOfWar clone = SpoilsOfWar(clones.clone(address(spoilsLogic)));
        // initialize the clone
        clone.initialize(address(token), merkleRoot);
        // send tokens
        token.transfer(address(clone), 100 * 1e18);
        address user = 0x606F388Dc144E3C3d8C87b76781BF92e5B053F12;
        bytes32[] memory proof = vm.parseJsonBytes32Array(
            vm.readFile("test/data.json"), ".data.0x606F388Dc144E3C3d8C87b76781BF92e5B053F12.proof"
        );
        vm.broadcast(user);
        clone.claim(user, 0, 25, proof);

        // user's balance should be up by 25 tokens
        assertEq(token.balanceOf(user), 25 * 1e18);
        // contract's balance should be down by 25 tokens
        assertEq(token.balanceOf(address(clone)), 75 * 1e18);
        // user should be marked as claimed
        assertEq(clone.claimed(0), true);

        // cannot double claim
        vm.expectRevert();
        clone.claim(user, 0, 25, proof);
    }
}
