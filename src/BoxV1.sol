// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

import {UUPSUpgradeable} from "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";


contract BoxV1 is OwnableUpgradeable, UUPSUpgradeable {
    uint256 private _value;
    uint256 private _version;

    event ValueChanged(uint256 value);

    function initialize(uint256 value) public initializer {
        __Ownable_init(msg.sender);
        __UUPSUpgradeable_init();
        _value = value;
        _version = 1;
    }

    function setValue(uint256 value) public {
        emit ValueChanged(value);
        _value = value;
    }

    function getValue() public view returns (uint256) {
        return _value;
    }

    function getVersion() public view returns (uint256) {
        return _version;
    }

    function _authorizeUpgrade(address newImplementation) internal override onlyOwner {}
}