//SPDX-License-Identifier: UNKNOWN
import "./appcore.sol";
pragma solidity ^0.8.7;

contract MarketplaceHelper is MarketplaceCore {
    function getUsers() external view returns (User[] memory) {
        User[] memory foundUsers = new User[](users.length);
        for (uint i = 0; i < users.length; i++) {
            foundUsers[i] = addressToUser[users[i]];
        }
        return foundUsers;
    }
    function getUser(address _userAddr) external view returns(User memory) {
        return addressToUser[_userAddr];
    }
    function getMarket(address _marketAddress) external view returns (Market memory) {
        return addressToMarket[_marketAddress];
    }

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