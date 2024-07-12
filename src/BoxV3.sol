// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

import {UUPSUpgradeable} from "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";


contract BoxV3 is OwnableUpgradeable, UUPSUpgradeable {
    uint256 private _number;
    uint256 private _version;

    event ValueChanged(uint256 value);

    // TODO: In test case try setting it to a different value
    function initializeV2(uint256 value) public reinitializer(3) {
        __Ownable_init(msg.sender);
        __UUPSUpgradeable_init();
        _number = value;
        _version = 3;
    }

    function setNumber(uint256 number) public {
        emit ValueChanged(number);
        _number = number;
    }

    function getValue() public view returns (uint256) {
        return _number;
    }

    function getVersion() public view returns (uint256) {
        return _version;
    }

    function _authorizeUpgrade(address newImplementation) internal override {}
}