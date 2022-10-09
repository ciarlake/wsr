//SPDX-License-Identifier: UNKNOWN

pragma solidity ^0.8.7;

contract MarketplaceCore {
    struct User {
        string  name;
        Role    role;
    }
    struct Market {
        string city;
        Item[] items;
    }
    struct Item {
        string name;
        uint   price;
        uint   priceDecimals;
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
        Comment[] comments;
    }
    struct Comment {
        address author;
        string body;
        RepData rep;
    }

    enum Role { Guest, Customer, Vendor, Supplier, Market, SystemAdministrator, Bank }

    address[] internal users;
    Review[] internal reviews;

    mapping (address => User) internal addressToUser;
    mapping (address => Market) internal addressToMarket;
    mapping (address => bytes32) internal addressToPassword;
}