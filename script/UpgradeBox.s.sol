// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

import {Script} from "forge-std/Script.sol";
import {BoxV2} from "../src/BoxV2.sol";
import {DevOpsTools} from "foundry-devops/contracts/DevOpsTools.sol";
import {BoxV1} from "../src/BoxV1.sol";

contract UpgradeBox is Script {

    function run() public returns (address) {
        return upgradeBox();
    }

    function upgradeBox() public returns (address) {
        // Get most recent deployed Proxy
        address boxV2Address = deployBoxV2();
        address proxyAddress = getMostRecentProxyDeployment();
        BoxV1 proxy = BoxV1(proxyAddress);
        bytes memory encodedData = abi.encodeWithSelector(BoxV2.initialize.selector, 603);
        vm.startBroadcast();
        proxy.upgradeToAndCall(boxV2Address, encodedData);
        vm.stopBroadcast();
        return address(proxy);
    }

    function deployBoxV2() public returns (address) {
        vm.startBroadcast();
        BoxV2 boxV2 = new BoxV2();
        vm.stopBroadcast();
        return address(boxV2);
    }

    function getMostRecentProxyDeployment() public view returns (address) {
       return DevOpsTools.get_most_recent_deployment("ERC1967Proxy", block.chainid);
    }
}

