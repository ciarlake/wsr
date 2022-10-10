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
        uint rating;
    }
    struct Comment {
        address author;
        string body;
    }

    enum Role { Guest, Customer, Vendor, Supplier, Market, SystemAdministrator, Bank }

    address[] internal users;
    Review[] internal reviews;
    Item[] internal items;

    mapping (address => bytes32) addressToWord;
    mapping (address => User) internal addressToUser;
    mapping (address => Market) internal addressToMarket;
    mapping (address => address) internal vendorToMarket;
    mapping (address => bytes32) internal addressToPassword;
    mapping (uint => RepData) internal reviewToRep;
    mapping (uint => RepData) internal commentToRep;
    mapping (uint => Comment[]) internal reviewToComments;
    mapping (uint => address) internal itemToMarket;

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
    // ! used for debug; delete this later
    function setRole(Role _role) external {
        addressToUser[msg.sender].role = _role;
    }

    function registerUser(string calldata _name, string calldata _password, string calldata _word) external {
        require(
            addressToUser[msg.sender].role == Role.Guest,
            "user already exists"
        );
        users.push(msg.sender);
        addressToUser[msg.sender] = User(_name, Role.Customer, 0);
        addressToPassword[msg.sender] = keccak256(abi.encode(_password));
        addressToWord[msg.sender] = keccak256(abi.encode(_word));
    }
    function authorize(string calldata _password, string calldata _word) external view accessLevel(Role.Customer) returns (User memory) {
        require(
            addressToPassword[msg.sender] == keccak256(abi.encode(_password)),
            "invalid password"
        );
        require(
            addressToWord[msg.sender] == keccak256(abi.encode(_word)),
            "invalid word"
        );

        return addressToUser[msg.sender];
    }
    
    struct Loan {
        address sender;
        uint repayed;
    }

    event MarketCreated(address _user, string _name, string _city);
    event MarketDeleted(address _user);

    Loan[] internal loans;

    function addMarket(address _user, string memory _city) external accessLevel(Role.SystemAdministrator) {
        Market memory newMkt = Market(_city);
        addressToUser[_user].role = Role.Market;
        addressToMarket[_user] = newMkt;
        emit MarketCreated(_user, addressToUser[_user].name, _city);
    }
    function removeMarket(address _user) external accessLevel(Role.SystemAdministrator) {
        for (uint i = 0; i < users.length; i++) {
            if(users[i] == _user) {
                _deleteMarketItems(_user);
                _demoteVendors(_user);
                delete addressToUser[users[i]];
                delete addressToMarket[users[i]];
                delete users[i]; 
                emit MarketDeleted(_user);
            }
        }
    }
    function requestLoan() external accessLevelExact(Role.Market) {
        for (uint i = 0; i < loans.length; i++){
            if (loans[i].sender == msg.sender) {
                if (loans[i].repayed == 1000) {
                    revert("you have already requested a loan");
                } else {
                    revert("repay all existing loans first");
                }
            }
        }
        loans.push(Loan(msg.sender, 1000));
    }
    function loanList() external view accessLevel(Role.Bank) returns (Loan[] memory) {
        return loans;
    }
    function approveLoan(address payable _market) external payable accessLevel(Role.Bank) {
        for (uint i = 0; i < loans.length; i++) {
            if (loans[i].sender == _market) {
                require(
                    msg.value == 1000 ether,
                    "insufficient ether"
                );
                loans[i].repayed = 0;
                _market.transfer(1000 ether);
                return;
            }
        }
        revert("market address not found");
    }
    function denyLoan(address _market) external accessLevel(Role.Bank) {
        for (uint i = 0; i < loans.length; i++) {
            if (loans[i].sender == _market) {
                _deleteLoan(i);
            }
        }
        revert("market address not found");
    }
    function repayLoan() external payable accessLevelExact(Role.Market) {
        for (uint i = 0; i < loans.length; i++) {
            if (loans[i].sender == msg.sender) {
                address payable bankWallet = payable(users[0]);
                if (msg.value >= (1000 ether - loans[i].repayed)) {
                    bankWallet.transfer(1000 ether - loans[i].repayed);
                    _deleteLoan(i);
                    return;
                } else {
                    bankWallet.transfer(msg.value);
                    loans[i].repayed -= msg.value;
                    return;
                }
            }
        }
        revert("no outgoing loans");
    }
    function _deleteLoan(uint _idx) internal {
            loans[_idx] = loans[loans.length - 1];
            delete loans[loans.length - 1];
            return;
    }
    function _deleteMarketItems(address _mkt) internal {
        for (uint i = 0; i < items.length; i++) {
            if (itemToMarket[i] == _mkt) {
                delete items[i];
            }
        }
    }
    function _demoteVendors(address _mkt) internal {
        for(uint i = 0; i < users.length; i++) {
            if (addressToUser[users[i]].role == Role.Vendor) {
                if (vendorToMarket[users[i]] == _mkt) {
                    addressToUser[users[i]].role = Role.Customer;
                }
            }
        }
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