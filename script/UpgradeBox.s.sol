// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

import {Script, console} from "forge-std/Script.sol";
import {BoxV2} from "../src/BoxV2.sol";
import {DevOpsTools} from "foundry-devops/src/DevOpsTools.sol";
import {BoxV1} from "../src/BoxV1.sol";

contract UpgradeBox is Script {

    function run() external returns (address) {
        address mostRecentlyDeployedBox = DevOpsTools.get_most_recent_deployment("BoxV1", block.chainid);
        console.log("Most Recently Deployed BoxV1: %s", mostRecentlyDeployedBox);
        address mostRecentlyDeployedProxy = DevOpsTools.get_most_recent_deployment("ERC1967Proxy", block.chainid);

        vm.startBroadcast();
        BoxV2 newBox = new BoxV2();
        vm.stopBroadcast();
        address proxy = upgradeBox(mostRecentlyDeployedProxy, address(newBox));
        return proxy;
    }

    function upgradeBox(address proxyAddress, address newBox) public returns (address) {
        vm.startBroadcast();
        BoxV1 proxy = BoxV1(payable(proxyAddress));
        proxy.upgradeToAndCall(address(newBox), abi.encodeWithSelector(BoxV2.initialize.selector, 603));
        vm.stopBroadcast();
        return address(proxy);
    }
}

