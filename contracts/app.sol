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
        uint vendorCount;
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
        uint commentCount;
    }
    struct Comment {
        address author;
        string body;
    }
    struct Loan {
        address sender;
        uint repayed;
    }
    struct VendorRequest {
        address sender;
        address market;
    }
    struct CustomerRequest {
        address sender;
    }

    enum Role { Guest, Customer, Vendor, Supplier, Market, SystemAdministrator, Bank }

    address[] internal users;
    Review[] internal reviews;
    Comment[] internal comments;
    Item[] internal items;
    Loan[] internal loans;
    VendorRequest[] internal vendorRequests;
    CustomerRequest[] internal customerRequests;

    mapping (address => bytes32) addressToWord;
    mapping (address => User) internal addressToUser;
    mapping (address => Market) internal addressToMarket;
    mapping (address => address) internal vendorToMarket;
    mapping (address => bytes32) internal addressToPassword;
    mapping (uint => RepData) internal reviewToRep;
    mapping (uint => RepData) internal commentToRep;
    mapping (uint => uint) internal commentToReview;
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
    function getVendors(address _market) external view returns (User[] memory) {
        User[] memory foundVendors = new User[](addressToMarket[_market].vendorCount);
        uint idx = 0;
        for (uint i = 0; i < users.length; i++) {
            if ((addressToUser[users[i]].role == Role.Vendor) && (vendorToMarket[users[i]] == _market)) {
                foundVendors[idx++] = addressToUser[users[i]];
            } 
        }
        return foundVendors;
    }
    // ! used for debug; delete this later
    function setRole(Role _role) external {
        addressToUser[msg.sender].role = _role;
    }
/*
*-------------------------------------
*   REGISTRATION AND AUTHORIZATION
*-------------------------------------
*/
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
    function authorize(string calldata _password) external view accessLevel(Role.Customer) returns (bool) {
        return addressToPassword[msg.sender] == keccak256(abi.encode(_password));
    }
    function checkWord(string calldata _word) external view accessLevel(Role.Customer) returns (User memory) {
        require(
            addressToWord[msg.sender] == keccak256(abi.encode(_word)),
            "invalid word"
        );

        return addressToUser[msg.sender];
    }
/*
*-----------------------
*   MARKET MANAGEMENT
*-----------------------
*/
    function addMarket(address _user, string memory _city) external accessLevel(Role.SystemAdministrator) {
        Market memory newMkt = Market(_city, 0, 0);
        addressToUser[_user].role = Role.Market;
        addressToMarket[_user] = newMkt;
    }
    function removeMarket(address _user) external accessLevel(Role.SystemAdministrator) {
        for (uint i = 0; i < users.length; i++) {
            if(users[i] == _user) {
                _deleteMarketItems(_user);
                _demoteVendors(_user);
                delete addressToUser[users[i]];
                delete addressToMarket[users[i]];
                delete users[i]; 
            }
        }
    }
    function requestLoan() external accessLevelExact(Role.Market) {
        for (uint i = 0; i < loans.length; i++){
            if (loans[i].sender == msg.sender) {
                if (loans[i].repayed == 1000 ether) {
                    revert("you have already requested a loan");
                } else {
                    revert("repay all existing loans first");
                }
            }
        }
        loans.push(Loan(msg.sender, 1000 ether));
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
/*
*-------------------------
*   REVIEWS & COMMENTS
*-------------------------
*/
    function getReviewsByMarket(address _market) external view returns(Review[] memory) {
        Review[] memory foundReviews = new Review[](addressToMarket[_market].reviewCount);
        uint idx;
        for (uint i = 0; i < reviews.length; i++) {
            if (reviews[i].market == _market) {
                foundReviews[idx++] = reviews[i];
            }
        }
        return foundReviews;
    }
    function getReviewsByAuthor(address _author) external view returns(Review[] memory) {
        Review[] memory foundReviews = new Review[](addressToUser[_author].reviewCount);
        uint idx;
        for (uint i = 0; i < reviews.length; i++) {
            if (reviews[i].author == _author) {
                foundReviews[idx++] = reviews[i];
            }
        }
        return foundReviews;
    }
    function createReview(address _market, string calldata _title, string calldata _body, uint _rating) external accessLevel(Role.Customer) {
        Review memory newRev = Review(msg.sender, _market, _title, _body, _rating, 0);
        reviews.push(newRev);
        addressToMarket[_market].reviewCount++;
    }
    function createComment(uint _reviewId, string calldata _body) external accessLevel(Role.Customer) {
        comments.push(Comment(msg.sender, _body));
        commentToReview[comments.length - 1] = _reviewId;
        reviews[_reviewId].commentCount++;
    }
    function getComments(uint _reviewId) external view returns(Comment[] memory) {
        Comment[] memory foundComments = new Comment[](reviews[_reviewId].commentCount);
        uint idx = 0;
        for (uint i = 0; i < comments.length; i++) {
            if (commentToReview[i] == _reviewId) {
                foundComments[idx++] = comments[i];
            }
        }
        return foundComments;
    }
    function likeReview(uint _reviewId) external {
        reviewToRep[_reviewId].likes.push(msg.sender);
    }
    function dislikeReview(uint _reviewId) external {
        reviewToRep[_reviewId].dislikes.push(msg.sender);
    }
    function removeReaction(uint _reviewId) external {
        for (uint i = 0; i < reviewToRep[_reviewId].likes.length; i++) {
            if (reviewToRep[_reviewId].likes[i] == msg.sender) {
                reviewToRep[_reviewId].likes[i] == reviewToRep[_reviewId].likes[reviewToRep[_reviewId].likes.length - 1];
                delete reviewToRep[_reviewId].likes[reviewToRep[_reviewId].likes.length - 1];
            } 
        }
        for (uint i = 0; i < reviewToRep[_reviewId].dislikes.length; i++) {
            if (reviewToRep[_reviewId].dislikes[i] == msg.sender) {
                reviewToRep[_reviewId].dislikes[i] == reviewToRep[_reviewId].dislikes[reviewToRep[_reviewId].dislikes.length - 1];
                delete reviewToRep[_reviewId].dislikes[reviewToRep[_reviewId].dislikes.length - 1];
            } 
        }
    }
    function likeComment(uint _commentId) external {
        commentToRep[_commentId].likes.push(msg.sender);
    }
    function dislikeComment(uint _commentId) external {
        commentToRep[_commentId].dislikes.push(msg.sender);
    }
    function removeCommentReaction(uint _commentId) external {
        for (uint i = 0; i < commentToRep[_commentId].likes.length; i++) {
            if (commentToRep[_commentId].likes[i] == msg.sender) {
                commentToRep[_commentId].likes[i] == commentToRep[_commentId].likes[commentToRep[_commentId].likes.length - 1];
                delete commentToRep[_commentId].likes[commentToRep[_commentId].likes.length - 1];
            } 
        }
        for (uint i = 0; i < commentToRep[_commentId].dislikes.length; i++) {
            if (commentToRep[_commentId].dislikes[i] == msg.sender) {
                commentToRep[_commentId].dislikes[i] == commentToRep[_commentId].dislikes[commentToRep[_commentId].dislikes.length - 1];
                delete commentToRep[_commentId].dislikes[commentToRep[_commentId].dislikes.length - 1];
            } 
        }
    }
    function getReviewReactions(uint _commentId) external view returns(uint, uint) {

    }
    
/*
*----------------------
*   USER MANAGEMENT
*----------------------
*/
    function requestVendor(address _market) external accessLevelExact(Role.Customer) {
        for (uint i = 0; i < vendorRequests.length; i++) {
            require(
                vendorRequests[i].sender != _market,
                "vendor request from this user already exists"
            );
        }
        vendorRequests.push(VendorRequest(msg.sender, _market));
    }
    function requestCustomer() external accessLevelExact(Role.Vendor) {
        customerRequests.push(CustomerRequest(msg.sender));
    }
    function listVendorRequests() external view accessLevelExact(Role.SystemAdministrator) returns(VendorRequest[] memory) {
        return vendorRequests;
    }
    function listCustomerRequests() external view accessLevelExact(Role.Vendor) returns (CustomerRequest[] memory) {
        return customerRequests;
    }
    function approveVendor(address _user) external accessLevelExact(Role.SystemAdministrator) {
        for (uint i = 0; i < vendorRequests.length; i++) {
            if (vendorRequests[i].sender == _user) {
                addressToUser[_user].role = Role.Vendor;
                vendorToMarket[_user] = vendorRequests[i].market;
                addressToMarket[vendorRequests[i].market].vendorCount++;
                _deleteVendorRequest(i);
                return;
            }
        }
        revert("user address not found");
    }
    function denyVendor(address _user) external accessLevelExact(Role.SystemAdministrator) {
        for (uint i = 0; i < vendorRequests.length; i++) {
            if (vendorRequests[i].sender == _user) {
                _deleteVendorRequest(i);
                return;
            }
        }   
        revert("user address not found");
    }
    function demoteVendor(address _vendor) external accessLevelExact(Role.SystemAdministrator) {
        require(
            addressToUser[_vendor].role == Role.Vendor,
            "user isn't a vendor"
        );
        addressToUser[_vendor].role == Role.Customer;
        addressToMarket[vendorToMarket[_vendor]].vendorCount--;
        delete vendorToMarket[_vendor];
    }
    function _deleteVendorRequest(uint _idx) internal {
        vendorRequests[_idx] = vendorRequests[vendorRequests.length - 1];
        delete vendorRequests[vendorRequests.length - 1]; 
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