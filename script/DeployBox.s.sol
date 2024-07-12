// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

import {Script} from "forge-std/Script.sol";
import {BoxV1} from "../src/BoxV1.sol";
import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";

contract DeployBox is Script {

    function run() public returns (address) {
        vm.startBroadcast();
        address proxy = deployBoxV1();
        vm.stopBroadcast();
        return proxy;
    }

    function deployBoxV1() public returns (address) {
        BoxV1 boxV1 = new BoxV1();
        bytes memory initializeData = abi.encodeWithSelector(BoxV1.initialize.selector, 506);
        ERC1967Proxy _proxy = new ERC1967Proxy(address(boxV1), initializeData);
        return address(_proxy);
    }
}

