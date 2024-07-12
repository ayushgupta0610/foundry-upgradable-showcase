// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

import {Test, console} from "forge-std/Test.sol";
import {DeployBox} from "../script/DeployBox.s.sol";
import {UpgradeBox} from "../script/UpgradeBox.s.sol";
import {BoxV1} from "../src/BoxV1.sol";
import {BoxV2} from "../src/BoxV2.sol";
import {DevOpsTools} from "foundry-devops/src/DevOpsTools.sol";

contract UpgradableBoxTest is Test {

    BoxV1 private boxV1;
    // BoxV2 private boxV2;
    address private proxy;

    function setUp() public {
        // Deploy BoxV1
        DeployBox deployBox = new DeployBox();
        proxy = deployBox.run();
        console.log("Proxy Address: %s", proxy);
        address expectedProxyAddress = DevOpsTools.get_most_recent_deployment("ERC1967Proxy", block.chainid);
        console.log("Expected Proxy Address: %s", expectedProxyAddress);
        boxV1 = BoxV1(proxy);
    }

    function testForVersionAndValue() public view {
        // Check if the version is 1
        assertEq(boxV1.getVersion(), 1);
        // Check if the value is 506
        assertEq(boxV1.getValue(), 506);
    }

    function testForUpgrade() public {
        // Upgrade BoxV1 to BoxV2
        UpgradeBox upgradeBox = new UpgradeBox();
        upgradeBox.run();
        // assertEq(BoxV2(proxy).getNumber(), 603);
        // Check if the version is 1
        assertEq(boxV1.getVersion(), 1);
        // Check if the value is 603
        assertEq(boxV1.getValue(), 603);
    }
    
    // function testForUpgrade() public {
    //     // Upgrade BoxV1 to BoxV2
    //     UpgradeBox upgradeBox = new UpgradeBox();
    //     address boxV2Address = upgradeBox.deployBoxV2();
    //     bytes memory encodedData = abi.encodeWithSelector(BoxV2.initialize.selector, 603);
    //     boxV1.upgradeToAndCall(boxV2Address, encodedData);
    //     // Check if the version is 1
    //     assertEq(boxV1.getVersion(), 2);
    //     // Check if the value is 603
    //     assertEq(boxV1.getValue(), 603);
    // }
}