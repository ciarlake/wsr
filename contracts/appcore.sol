//SPDX-License-Identifier: UNKNOWN

pragma solidity ^0.8.7;

contract MarketplaceCore {
    struct User {
        string  name;
        Role    role;
        uint    reviewCount;
    }
    struct Market {
        string city;
        uint reviewCount;
    }
    struct Item {
        string name;
        uint   price;
    }
    struct RepData {
        address[] likes;
        address[] dislikes;
    }
    struct Review {
        address author;
        address market;
        string title;
        string body;
        RepData rep;
        uint rating;
        uint[] comments;
    }
    struct Comment {
        address author;
        string body;
        RepData rep;
    }

    enum Role { Guest, Customer, Vendor, Supplier, Market, SystemAdministrator, Bank }

    address[] internal users;
    Review[] internal reviews;
    Item[] internal items;
    Comment[] internal comments;

    mapping (address => User) internal addressToUser;
    mapping (address => Market) internal addressToMarket;
    mapping (address => address) internal vendorToMarket;
    mapping (address => bytes32) internal addressToPassword;

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
    function getMarket(address _marketAddress) external view returns(Market memory) {
        return addressToMarket[_marketAddress];
    }
    function getVendorMarket(address _vendor) external view returns(address) {
        return vendorToMarket[_vendor];
    }
}