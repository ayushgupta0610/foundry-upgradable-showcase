// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

import {Test, console} from "forge-std/Test.sol";
import {DeployBox} from "../script/DeployBox.s.sol";
import {UpgradeBox} from "../script/UpgradeBox.s.sol";
import {BoxV1} from "../src/BoxV1.sol";
import {BoxV2} from "../src/BoxV2.sol";
import {BoxV3} from "../src/BoxV3.sol";
import {DevOpsTools} from "foundry-devops/src/DevOpsTools.sol";
import {UUPSUpgradeable} from "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

contract UpgradableBoxTest is Test {

    BoxV1 private boxV1;
    // BoxV2 private boxV2;
    address private proxy;

    function setUp() public {
        // Deploy BoxV1
        DeployBox deployBox = new DeployBox();
        proxy = deployBox.run();
        boxV1 = BoxV1(proxy);
    }

    function testForVersionAndValue() public view {
        // Check if the version is 1
        assertEq(boxV1.getVersion(), 1);
        // Check if the value is 506
        assertEq(boxV1.getValue(), 506);
    }

    // function testForUpgrade() public {
    //     // Upgrade BoxV1 to BoxV2
    //     UpgradeBox upgradeBox = new UpgradeBox();
    //     upgradeBox.run();
    //     // assertEq(BoxV2(proxy).getNumber(), 603);
    //     // Check if the version is 1
    //     assertEq(boxV1.getVersion(), 1);
    //     // Check if the value is 603
    //     assertEq(boxV1.getValue(), 603);
    // }
    
    function testForUpgrade() public {
        // Upgrade BoxV1 to BoxV2
        BoxV2 boxV2 = new BoxV2();
        bytes memory encodedData = abi.encodeWithSelector(BoxV2.initializeV2.selector, 603);
        BoxV1(proxy).upgradeToAndCall(address(boxV2), encodedData);
        // Check if the version is 2
        assertEq(boxV1.getVersion(), 2);
        // Check if the value is 603
        assertEq(boxV1.getValue(), 603);


        // Another deployment via UUPS
        BoxV3 boxV3 = new BoxV3();
        bytes memory encodedDataV3 = abi.encodeWithSelector(BoxV3.initializeV2.selector, 601);
        BoxV1(proxy).upgradeToAndCall(address(boxV3), encodedDataV3);
        // Check if the version is 3
        assertEq(boxV1.getVersion(), 3);
        // Check if the value is 601
        assertEq(boxV1.getValue(), 601);
        
    }
}