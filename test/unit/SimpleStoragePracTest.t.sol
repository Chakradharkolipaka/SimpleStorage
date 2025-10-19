//SPDX-License-Identifier:MIT
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import {SimpleStoragePrac} from "../../src/SimpleStoragePrac.sol";
import {DeploySimpleStoragePrac} from "../../script/DeploySimpleStoragePrac.s.sol";

contract SimpleStoragePracTest is Test {
    SimpleStoragePrac simpleStoragePrac;

    error simpleStoragePrac__NotAdded();

    struct User {
        string name;
        uint256 fav;
    }

    function setUp() external {
        simpleStoragePrac = new SimpleStoragePrac();

        // DeploySimpleStoragePrac deploySimpleStoragePrac = new DeploySimpleStoragePrac();
        // deploySimpleStoragePrac.run();
    }

    //if an assert fails ->test fails

    function testAddPersonStoredInUsers() public {
        (uint256 count1, ) = simpleStoragePrac.listOfMembers();
        simpleStoragePrac.addPerson("chakri", 2);
        (uint256 count2, ) = simpleStoragePrac.listOfMembers();
        assertNotEq(count1, count2);
        // if (count2 == count1) revert simpleStoragePrac__NotAdded();
    }

    function testAddPersonRevertIfNameIsEmpty() public {
        vm.expectRevert(
            SimpleStoragePrac.SimpleStoragePrac__EmptyName.selector
        );
        simpleStoragePrac.addPerson("", 9);
    }

    function testAddPersonRevertIfNameExists() public {
        simpleStoragePrac.addPerson("chakri", 2);
        vm.expectRevert(
            SimpleStoragePrac.SimpleStoragePrac__NameExists.selector
        );
        simpleStoragePrac.addPerson("chakri", 2);
    }

    function testAddPersonStoredInNameToFavNum() public {
        simpleStoragePrac.addPerson("pk", 91);
        uint256 fav = simpleStoragePrac.nameToFavNumValues("pk");
        assertEq(91, fav);
        // if (fav != 91) revert simpleStoragePrac__NotAdded();
    }

    function testAddPersonStoredInNameIndex() public {
        simpleStoragePrac.addPerson("padhu", 99);
        uint256 idx = simpleStoragePrac.nameIndexIdx("padhu");
        assertNotEq(0, idx);
        // if (idx == 0) revert simpleStoragePrac__NotAdded();
    }

    function testRetrieveFavByNameRevertsIfMismatchs() public {
        simpleStoragePrac.addPerson("padhu", 99);
        simpleStoragePrac.addPerson("chandhana", 95);
        assertEq(99, simpleStoragePrac.retrieveFavByName("padhu"));
    }

    function testRetrieveFavByNameRevertIfNameIsEmpty() public {
        vm.expectRevert(
            SimpleStoragePrac.SimpleStoragePrac__EmptyName.selector
        );
        simpleStoragePrac.retrieveFavByName("");
    }

    function testListOfMembersRevertsIfMismatchs() public {
        simpleStoragePrac.addPerson("c1", 998);
        simpleStoragePrac.addPerson("c2", 999);

        (
            uint256 count,
            SimpleStoragePrac.User[] memory users
        ) = simpleStoragePrac.listOfMembers();
        assertEq(2, count);

        assertEq(users[0].name, "c1");
        assertEq(users[0].fav, 998);
        assertEq(users[1].name, "c2");
        assertEq(users[1].fav, 999);
    }

    function testModifyRevertIfNameIsEmpty() public {
        vm.expectRevert(
            SimpleStoragePrac.SimpleStoragePrac__EmptyName.selector
        );
        simpleStoragePrac.modify("", 9);
    }

    function testModifyRevertIfNameNotFound() public {
        vm.expectRevert(SimpleStoragePrac.SimpleStoragePrac__NotFound.selector);
        simpleStoragePrac.modify("cherry", 88);
    }

    function testModify() public {
        simpleStoragePrac.addPerson("chakri", 1);
        uint256 fav1 = simpleStoragePrac.nameToFavNumValues("chakri");
        simpleStoragePrac.modify("chakri", 2);
        uint256 fav2 = simpleStoragePrac.nameToFavNumValues("chakri");
        assertNotEq(fav1, fav2);
    }

    function testRemoveRevertIfNameIsEmpty() public {
        vm.expectRevert(
            SimpleStoragePrac.SimpleStoragePrac__EmptyName.selector
        );
        simpleStoragePrac.remove("");
    }

    function testRemoveRevertIfNameNotFound() public {
        vm.expectRevert(SimpleStoragePrac.SimpleStoragePrac__NotFound.selector);
        simpleStoragePrac.remove("cherry");
    }

    function testRemove() public {
        simpleStoragePrac.addPerson("chakri", 1);
        uint256 fav1 = simpleStoragePrac.nameToFavNumValues("chakri");
        simpleStoragePrac.remove("chakri");
        uint256 fav2 = simpleStoragePrac.nameToFavNumValues("chakri");
        assertNotEq(fav1, fav2);
    }
}
