//SPDX-License-Identifier: UNKNOWN
import "./appcore.sol";
pragma solidity ^0.8.7;

contract MarketplaceHelper is MarketplaceCore {
    modifier accessLevel(Role _required) {
        require (
            addressToUser[msg.sender].role >= _required,
            "access denied"
        );
        _;
    }
    modifier accessLevelExact(Role _required) {
        require(
            addressToUser[msg.sender].role == _required,
            "access denied"
        );
        _;
    }
}