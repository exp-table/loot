// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {Script} from "forge-std/Script.sol";

import {Clones} from "src/Clones.sol";
import {Loot} from "src/Loot.sol";

contract Deploy is Script {

    function run() external returns (Clones clones, Loot lootLogic) {
        string memory RPC_ETH = vm.envString("RPC_URL");
        vm.createSelectFork(RPC_ETH);
        uint256 deployerPrivateKey = vm.envUint("DEPLOYER_KEY");
        vm.startBroadcast(deployerPrivateKey);
        clones = new Clones();
        lootLogic = new Loot();
        vm.stopBroadcast();
    }
}
