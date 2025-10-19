//SPDX-License-Identifier:MIT
pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";
import {DeploySimpleStoragePrac} from "../../script/DeploySimpleStoragePrac.s.sol";
import {SimpleStoragePrac} from "../../src/SimpleStoragePrac.sol";
contract DeploySSTest is Test{
    error DeploySSTest__AddressIsZero();
    SimpleStoragePrac public simpleStorage;
    DeploySimpleStoragePrac public deployer;

    function setUp() external{
        deployer = new DeploySimpleStoragePrac();
    }

    function testScriptDeploysContract() public{
        simpleStorage = deployer.run();
        assertNotEq(address(simpleStorage),address(0));
    }

    function testScriptReturnsValidAddress() public{
        simpleStorage = deployer.run();
        assertNotEq(address(simpleStorage).code.length,0);
    } 

    function testScriptDeploysMultipleTimes() public{
        SimpleStoragePrac storage1 = deployer.run();
        SimpleStoragePrac storage2 = deployer.run();
        assertNotEq(address(storage1),address(storage2));
    }

    function testScriptDeploymentGas() public{
        uint256 gasBefore = gasleft();
        deployer.run();
        uint256 gasUsed = gasBefore - gasleft();

        assertLt(gasUsed,1_500_000);
    }

}