//SPDX-Licensei-Identifier:MIT
pragma solidity ^0.8.24;

import "forge-std/Script.sol";
import {SimpleStoragePrac} from "../src/SimpleStoragePrac.sol";

contract DeploySimpleStoragePrac is Script{
    function run() external returns(SimpleStoragePrac){
        vm.startBroadcast();
        SimpleStoragePrac simpleStoragePrac = new SimpleStoragePrac();
        vm.stopBroadcast();

        return simpleStoragePrac;
    }
}