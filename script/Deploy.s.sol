// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {Script} from "forge-std/Script.sol";

import {Clones} from "src/Clones.sol";
import {SpoilsOfWar} from "src/SpoilsOfWar.sol";
import {ERC20Mock} from "test/ERC20Mock.sol";

contract Deploy is Script {
    function run() external returns (Clones clones, SpoilsOfWar spoilsLogic, ERC20Mock erc20Mock) {
        string memory RPC_ETH = vm.envString("RPC_URL");
        uint256 deployerPrivateKey = vm.envUint("DEPLOYER_KEY");
        vm.startBroadcast();
        clones = new Clones();
        spoilsLogic = new SpoilsOfWar();
        erc20Mock = new ERC20Mock();

        vm.stopBroadcast();
    }
}
