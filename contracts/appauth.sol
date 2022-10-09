// SPDX-License-Identifier: UNKNOWN
pragma solidity ^0.8.7;
import "./appcore.sol";

contract MarketplaceAuth is MarketplaceCore {
    function registerUser(string calldata _name, string calldata _password) external {
        require(
            addressToUser[msg.sender].role == Role.Guest,
            "user already exists"
        );

        users.push(msg.sender);
        addressToUser[msg.sender] = User(_name, Role.Customer);
        addressToPassword[msg.sender] = keccak256(abi.encode(_password));
    }
}