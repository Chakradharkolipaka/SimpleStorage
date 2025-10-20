//SPDX-License-Identifier:MIT
pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";
import {SimpleStoragePrac} from "../../src/SimpleStoragePrac.sol";
import {DeploySimpleStoragePrac}from "../../script/DeploySimpleStoragePrac.s.sol";

contract SimpleStorageTest is Test{
    SimpleStoragePrac public simpleStoragePrac;

    string public constant NAME1 = "chakradhar";
    string public constant NAME2 = "chakri";
    uint256 public constant FAV1 = 1;
    uint256 public constant FAV2 = 21;
    uint256 public NEW_NUM = 21;
    
    function setUp() external{
        DeploySimpleStoragePrac deployer = new DeploySimpleStoragePrac();
        simpleStoragePrac = deployer.run();
    }

    function testModifyRevertsIfNoChange() public{
        simpleStoragePrac.addPerson(NAME1,FAV1);
        simpleStoragePrac.addPerson(NAME2,FAV2);
        
        uint256 fav1 = simpleStoragePrac.nameToFavNumValues(NAME1);
        simpleStoragePrac.modify(NAME1,NEW_NUM);
        uint256 fav2 = simpleStoragePrac.nameToFavNumValues(NAME1);

        assertEq(fav1,FAV1);
        assertEq(fav2,NEW_NUM);
        assertNotEq(fav1,fav2);
    }

    function testRemoveRevertsIfNoChange() public{
        simpleStoragePrac.addPerson(NAME1,FAV1);
        simpleStoragePrac.addPerson(NAME2,FAV2);

        (uint256 count1 , ) = simpleStoragePrac.listOfMembers();
        simpleStoragePrac.remove(NAME1);
        (uint256 count2 , ) = simpleStoragePrac.listOfMembers();

        assertNotEq(count1,count2);
    }

}