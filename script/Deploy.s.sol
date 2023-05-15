// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {Script} from "forge-std/Script.sol";

import {Clones} from "src/Clones.sol";
import {SnapSomething} from "src/SnapSomething.sol";

contract Deploy is Script {

    function run() external returns (Clones clones, SnapSomething snapLogic) {
        string memory RPC_ETH = vm.envString("RPC_URL");
        uint256 deployerPrivateKey = vm.envUint("DEPLOYER_KEY");
        vm.startBroadcast();
        clones = new Clones();
        snapLogic = new SnapSomething();
        vm.stopBroadcast();
    }
}
