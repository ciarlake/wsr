//SPDX-License-Identifier: UNKNOWN

pragma solidity ^0.8.7;

contract MarketplaceCore {
    constructor() {
        users.push(0x260cFFEc6b488a8031FD2950E8827faC370923Bf);
        addressToUser[0x260cFFEc6b488a8031FD2950E8827faC370923Bf] = User(
            unicode"Банк",
            Role.Bank,
            0
        );

        users.push(0xb430e86Dea7705D8cbb988d14Ed82982aaBDE031);
        addressToUser[0xb430e86Dea7705D8cbb988d14Ed82982aaBDE031] = User(
            unicode"Магазин №1",
            Role.Market,
            0
        );
        addressToMarket[0xb430e86Dea7705D8cbb988d14Ed82982aaBDE031] = Market(
            unicode"Дмитров",
            0,
            0
        );

        users.push(0x31d874819557992F9072cfcd621a2CDF5917C77a);
        addressToUser[0x31d874819557992F9072cfcd621a2CDF5917C77a] = User(
            unicode"Магазин №2",
            Role.Market,
            0
        );
        addressToMarket[0x31d874819557992F9072cfcd621a2CDF5917C77a] = Market(
            unicode"Калуга",
            0,
            0
        );

        users.push(0x6e36B1C4cA02564e8C444a24907AE0CE4a838e7a);
        addressToUser[0x6e36B1C4cA02564e8C444a24907AE0CE4a838e7a] = User(
            unicode"Магазин №3",
            Role.Market,
            0
        );
        addressToMarket[0x6e36B1C4cA02564e8C444a24907AE0CE4a838e7a] = Market(
            unicode"Москва",
            0,
            0
        );

        users.push(0x88f61913A6F47e64c9dEa4950D85130E8Cd77945);
        addressToUser[0x88f61913A6F47e64c9dEa4950D85130E8Cd77945] = User(
            unicode"Магазин №4",
            Role.Market,
            0
        );
        addressToMarket[0x88f61913A6F47e64c9dEa4950D85130E8Cd77945] = Market(
            unicode"Рязань",
            0,
            0
        );

        users.push(0x1F25FAfFc2447C923304791658c4882973bD3C2a);
        addressToUser[0x1F25FAfFc2447C923304791658c4882973bD3C2a] = User(
            unicode"Магазин №5",
            Role.Market,
            0
        );
        addressToMarket[0x1F25FAfFc2447C923304791658c4882973bD3C2a] = Market(
            unicode"Самара",
            0,
            0
        );

        users.push(0x69eD840CBFd58A93193a2A5EF5Fb8b80B90EcD15);
        addressToUser[0x69eD840CBFd58A93193a2A5EF5Fb8b80B90EcD15] = User(
            unicode"Магазин №6",
            Role.Market,
            0
        );
        addressToMarket[0x69eD840CBFd58A93193a2A5EF5Fb8b80B90EcD15] = Market(
            unicode"Санкт-Петербург",
            0,
            0
        );

        users.push(0x455da86808cE6D0e73B064126BaE58Fcff72DD60);
        addressToUser[0x455da86808cE6D0e73B064126BaE58Fcff72DD60] = User(
            unicode"Магазин №7",
            Role.Market,
            0
        );
        addressToMarket[0x455da86808cE6D0e73B064126BaE58Fcff72DD60] = Market(
            unicode"Таганрог",
            0,
            0
        );

        users.push(0x2528D7Af808B0D458039d421756dc308D9bC18F2);
        addressToUser[0x2528D7Af808B0D458039d421756dc308D9bC18F2] = User(
            unicode"Магазин №8",
            Role.Market,
            0
        );
        addressToMarket[0x2528D7Af808B0D458039d421756dc308D9bC18F2] = Market(
            unicode"Томск",
            0,
            0
        );

        users.push(0xC2eddCFDE6a1629EFD098Ad1D6024cBc82439C43);
        addressToUser[0xC2eddCFDE6a1629EFD098Ad1D6024cBc82439C43] = User(
            unicode"Магазин №9",
            Role.Market,
            0
        );
        addressToMarket[0xC2eddCFDE6a1629EFD098Ad1D6024cBc82439C43] = Market(
            unicode"Хабаровск",
            0,
            0
        );

        users.push(0xFFdaB5A9F222A96d78822486417508229CedB698);
        addressToUser[0xFFdaB5A9F222A96d78822486417508229CedB698] = User(
            unicode"Поставщик Золотая Рыбка",
            Role.Vendor,
            0
        );

        users.push(0x3Dc5eaCBb57B4a935e186386152e408428A7e8eE);
        addressToUser[0x3Dc5eaCBb57B4a935e186386152e408428A7e8eE] = User(
            unicode"Иванов Иван Иванович",
            Role.SystemAdministrator,
            0
        );

        users.push(0x0deC193d2D20A65AF83BEC89738477228191c6a5);
        addressToUser[0x0deC193d2D20A65AF83BEC89738477228191c6a5] = User(
            unicode"Семенов Семен Семенович",
            Role.Vendor,
            0
        );
        vendorToMarket[
            0x0deC193d2D20A65AF83BEC89738477228191c6a5
        ] = 0xb430e86Dea7705D8cbb988d14Ed82982aaBDE031;

        users.push(0x3e4117F5e6eB699b2a012e3B0fAEaE37bb4AaBa4);
        addressToUser[0x3e4117F5e6eB699b2a012e3B0fAEaE37bb4AaBa4] = User(
            unicode"Петров Петр Петрович",
            Role.Customer,
            0
        );
    }

    struct User {
        string name;
        Role role;
        uint256 reviewCount;
    }
    struct Market {
        string city;
        uint256 reviewCount;
        uint256 vendorCount;
    }
    struct Item {
        string name;
        string manufacurer;
        string storageTemperature;
        uint256 price;
        uint256 productionDate;
        uint256 shelfLife;
        Measurement measurement;
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
        uint256 rating;
        uint256 commentCount;
    }
    struct Comment {
        address author;
        string body;
    }
    struct Loan {
        address sender;
        uint256 repayed;
    }
    struct VendorRequest {
        address sender;
        address market;
    }
    struct CustomerRequest {
        address sender;
    }

    enum Measurement {
        Kilogram,
        Unit
    }

    enum Role {
        Guest,
        Customer,
        Vendor,
        Supplier,
        Market,
        SystemAdministrator,
        Bank
    }

    address[] internal users;
    Review[] internal reviews;
    Comment[] internal comments;
    Item[] internal items;
    Loan[] internal loans;
    VendorRequest[] internal vendorRequests;
    CustomerRequest[] internal customerRequests;

    mapping(address => bytes32) addressToWord;
    mapping(address => User) internal addressToUser;
    mapping(address => Market) internal addressToMarket;
    mapping(address => address) internal vendorToMarket;
    mapping(address => bytes32) internal addressToPassword;
    mapping(uint256 => RepData) internal reviewToRep;
    mapping(uint256 => RepData) internal commentToRep;
    mapping(uint256 => uint256) internal commentToReview;
    mapping(uint256 => address) internal itemToMarket;
    mapping(uint256 => address) internal itemToVendor;
    mapping(address => Role) internal roleLookup;

    function getUsers() external view returns (User[] memory) {
        User[] memory foundUsers = new User[](users.length);
        for (uint256 i = 0; i < users.length; i++) {
            foundUsers[i] = addressToUser[users[i]];
        }
        return foundUsers;
    }

    function getUser(address _userAddr) external view returns (User memory) {
        return addressToUser[_userAddr];
    }

    function getMarket(address _marketAddress)
        external
        view
        returns (Market memory)
    {
        return addressToMarket[_marketAddress];
    }

    function getVendorMarket(address _vendor) external view returns (address) {
        return vendorToMarket[_vendor];
    }

    function getVendors(address _market)
        external
        view
        returns (address[] memory)
    {
        address[] memory foundVendors = new address[](
            addressToMarket[_market].vendorCount
        );
        uint256 idx = 0;
        for (uint256 i = 0; i < users.length; i++) {
            if (
                (addressToUser[users[i]].role == Role.Vendor) &&
                (vendorToMarket[users[i]] == _market)
            ) {
                foundVendors[idx++] = users[i];
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
    function registerUser(
        string calldata _name,
        string calldata _password,
        string calldata _word
    ) external {
        require(
            addressToUser[msg.sender].role == Role.Guest,
            "user already exists"
        );
        users.push(msg.sender);
        addressToUser[msg.sender] = User(_name, Role.Customer, 0);
        addressToPassword[msg.sender] = keccak256(abi.encode(_password));
        addressToWord[msg.sender] = keccak256(abi.encode(_word));
    }

    function authorize(string calldata _password)
        external
        view
        accessLevel(Role.Customer)
        returns (bool)
    {
        return
            addressToPassword[msg.sender] == keccak256(abi.encode(_password));
    }

    function checkWord(string calldata _word)
        external
        view
        accessLevel(Role.Customer)
        returns (User memory)
    {
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
    function addMarket(address _user, string memory _city)
        external
        accessLevel(Role.SystemAdministrator)
    {
        Market memory newMkt = Market(_city, 0, 0);
        addressToUser[_user].role = Role.Market;
        addressToMarket[_user] = newMkt;
    }

    function removeMarket(address _user)
        external
        accessLevel(Role.SystemAdministrator)
    {
        for (uint256 i = 0; i < users.length; i++) {
            if (users[i] == _user) {
                _deleteMarketItems(_user);
                _demoteVendors(_user);
                delete addressToUser[users[i]];
                delete addressToMarket[users[i]];
                delete users[i];
            }
        }
    }

    function requestLoan() external accessLevelExact(Role.Market) {
        for (uint256 i = 0; i < loans.length; i++) {
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

    function loanList()
        external
        view
        accessLevel(Role.Bank)
        returns (Loan[] memory)
    {
        return loans;
    }

    function approveLoan(address payable _market)
        external
        payable
        accessLevel(Role.Bank)
    {
        for (uint256 i = 0; i < loans.length; i++) {
            if (loans[i].sender == _market) {
                require(msg.value == 1000 ether, "insufficient ether");
                loans[i].repayed = 0;
                _market.transfer(1000 ether);
                return;
            }
        }
        revert("market address not found");
    }

    function denyLoan(address _market) external accessLevel(Role.Bank) {
        for (uint256 i = 0; i < loans.length; i++) {
            if (loans[i].sender == _market) {
                _deleteLoan(i);
            }
        }
        revert("market address not found");
    }

    function repayLoan() external payable accessLevelExact(Role.Market) {
        for (uint256 i = 0; i < loans.length; i++) {
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

    function _deleteLoan(uint256 _idx) internal {
        loans[_idx] = loans[loans.length - 1];
        delete loans[loans.length - 1];
        return;
    }

    function _deleteMarketItems(address _mkt) internal {
        for (uint256 i = 0; i < items.length; i++) {
            if (itemToMarket[i] == _mkt) {
                delete items[i];
            }
        }
    }

    function _demoteVendors(address _mkt) internal {
        for (uint256 i = 0; i < users.length; i++) {
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
    function getReviewsByMarket(address _market)
        external
        view
        returns (Review[] memory)
    {
        Review[] memory foundReviews = new Review[](
            addressToMarket[_market].reviewCount
        );
        uint256 idx;
        for (uint256 i = 0; i < reviews.length; i++) {
            if (reviews[i].market == _market) {
                foundReviews[idx++] = reviews[i];
            }
        }
        return foundReviews;
    }

    function getReviewsByAuthor(address _author)
        external
        view
        returns (Review[] memory)
    {
        Review[] memory foundReviews = new Review[](
            addressToUser[_author].reviewCount
        );
        uint256 idx;
        for (uint256 i = 0; i < reviews.length; i++) {
            if (reviews[i].author == _author) {
                foundReviews[idx++] = reviews[i];
            }
        }
        return foundReviews;
    }

    function createReview(
        address _market,
        string calldata _title,
        string calldata _body,
        uint256 _rating
    ) external accessLevel(Role.Customer) {
        Review memory newRev = Review(
            msg.sender,
            _market,
            _title,
            _body,
            _rating,
            0
        );
        if (addressToUser[msg.sender].role == Role.Vendor) {
            require(vendorToMarket[msg.sender] == _market, "access denied");
        }
        reviews.push(newRev);
        addressToMarket[_market].reviewCount++;
    }

    function createComment(uint256 _reviewId, string calldata _body)
        external
        accessLevel(Role.Customer)
    {
        comments.push(Comment(msg.sender, _body));
        commentToReview[comments.length - 1] = _reviewId;
        reviews[_reviewId].commentCount++;
    }

    function getComments(uint256 _reviewId)
        external
        view
        returns (Comment[] memory)
    {
        Comment[] memory foundComments = new Comment[](
            reviews[_reviewId].commentCount
        );
        uint256 idx = 0;
        for (uint256 i = 0; i < comments.length; i++) {
            if (commentToReview[i] == _reviewId) {
                foundComments[idx++] = comments[i];
            }
        }
        return foundComments;
    }

    function likeReview(uint256 _reviewId) external {
        reviewToRep[_reviewId].likes.push(msg.sender);
    }

    function dislikeReview(uint256 _reviewId) external {
        reviewToRep[_reviewId].dislikes.push(msg.sender);
    }

    function removeReaction(uint256 _reviewId) external {
        for (uint256 i = 0; i < reviewToRep[_reviewId].likes.length; i++) {
            if (reviewToRep[_reviewId].likes[i] == msg.sender) {
                reviewToRep[_reviewId].likes[i] ==
                    reviewToRep[_reviewId].likes[
                        reviewToRep[_reviewId].likes.length - 1
                    ];
                delete reviewToRep[_reviewId].likes[
                    reviewToRep[_reviewId].likes.length - 1
                ];
            }
        }
        for (uint256 i = 0; i < reviewToRep[_reviewId].dislikes.length; i++) {
            if (reviewToRep[_reviewId].dislikes[i] == msg.sender) {
                reviewToRep[_reviewId].dislikes[i] ==
                    reviewToRep[_reviewId].dislikes[
                        reviewToRep[_reviewId].dislikes.length - 1
                    ];
                delete reviewToRep[_reviewId].dislikes[
                    reviewToRep[_reviewId].dislikes.length - 1
                ];
            }
        }
    }

    function likeComment(uint256 _commentId) external {
        commentToRep[_commentId].likes.push(msg.sender);
    }

    function dislikeComment(uint256 _commentId) external {
        commentToRep[_commentId].dislikes.push(msg.sender);
    }

    function removeCommentReaction(uint256 _commentId) external {
        for (uint256 i = 0; i < commentToRep[_commentId].likes.length; i++) {
            if (commentToRep[_commentId].likes[i] == msg.sender) {
                commentToRep[_commentId].likes[i] ==
                    commentToRep[_commentId].likes[
                        commentToRep[_commentId].likes.length - 1
                    ];
                delete commentToRep[_commentId].likes[
                    commentToRep[_commentId].likes.length - 1
                ];
            }
        }
        for (uint256 i = 0; i < commentToRep[_commentId].dislikes.length; i++) {
            if (commentToRep[_commentId].dislikes[i] == msg.sender) {
                commentToRep[_commentId].dislikes[i] ==
                    commentToRep[_commentId].dislikes[
                        commentToRep[_commentId].dislikes.length - 1
                    ];
                delete commentToRep[_commentId].dislikes[
                    commentToRep[_commentId].dislikes.length - 1
                ];
            }
        }
    }

    function getReviewReactions(uint256 _reviewId)
        external
        view
        returns (uint256, uint256)
    {
        return (
            reviewToRep[_reviewId].likes.length,
            reviewToRep[_reviewId].dislikes.length
        );
    }

    /*
     *----------------------
     *   USER MANAGEMENT
     *----------------------
     */
    function switchOnCustomerView() external accessLevel(Role.Market) {
        roleLookup[msg.sender] = addressToUser[msg.sender].role;
        addressToUser[msg.sender].role = Role.Customer;
    }

    function switchOffCustomerView() external accessLevel(Role.Customer) {
        require(
            roleLookup[msg.sender] != Role(0),
            "customer view has not been toggled"
        );

        addressToUser[msg.sender].role = roleLookup[msg.sender];
        delete roleLookup[msg.sender];
    }

    function addVendor(address _user, address _market)
        external
        accessLevel(Role.SystemAdministrator)
    {
        require(
            addressToUser[_user].role != Role.Vendor,
            "user is already a vendor"
        );

        addressToUser[_user].role = Role.Vendor;
        addressToMarket[_market].vendorCount++;
        vendorToMarket[_user] = _market;
    }

    function removeVendor(address _user, address _market)
        external
        accessLevel(Role.SystemAdministrator)
    {
        require(
            addressToUser[_user].role == Role.Vendor,
            "user is not a vendor"
        );

        addressToUser[_user].role = Role.Customer;
        addressToMarket[_market].vendorCount--;
        delete vendorToMarket[_user];
    }

    function addAdmin(address _userId)
        external
        accessLevel(Role.SystemAdministrator)
    {
        addressToUser[_userId].role = Role.SystemAdministrator;
    }

    function requestVendor(address _market)
        external
        accessLevelExact(Role.Customer)
    {
        for (uint256 i = 0; i < vendorRequests.length; i++) {
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

    function listVendorRequests()
        external
        view
        accessLevelExact(Role.SystemAdministrator)
        returns (VendorRequest[] memory)
    {
        return vendorRequests;
    }

    function listCustomerRequests()
        external
        view
        accessLevelExact(Role.Vendor)
        returns (CustomerRequest[] memory)
    {
        return customerRequests;
    }

    function approveVendor(address _user)
        external
        accessLevelExact(Role.SystemAdministrator)
    {
        for (uint256 i = 0; i < vendorRequests.length; i++) {
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

    function denyVendor(address _user)
        external
        accessLevelExact(Role.SystemAdministrator)
    {
        for (uint256 i = 0; i < vendorRequests.length; i++) {
            if (vendorRequests[i].sender == _user) {
                _deleteVendorRequest(i);
                return;
            }
        }
        revert("user address not found");
    }

    function demoteVendor(address _vendor)
        external
        accessLevelExact(Role.SystemAdministrator)
    {
        require(
            addressToUser[_vendor].role == Role.Vendor,
            "user isn't a vendor"
        );
        addressToUser[_vendor].role == Role.Customer;
        addressToMarket[vendorToMarket[_vendor]].vendorCount--;
        delete vendorToMarket[_vendor];
    }

    function _deleteVendorRequest(uint256 _idx) internal {
        vendorRequests[_idx] = vendorRequests[vendorRequests.length - 1];
        delete vendorRequests[vendorRequests.length - 1];
    }

    modifier accessLevel(Role _required) {
        require(addressToUser[msg.sender].role >= _required, "access denied");
        _;
    }
    modifier accessLevelExact(Role _required) {
        require(addressToUser[msg.sender].role == _required, "access denied");
        _;
    }

    /*
     *-----------------------
     *   ITEMS & VENDORS
     *-----------------------
     */

    function createItem(
        string calldata _name,
        string calldata _manufacturer,
        string calldata _storageTemperature,
        uint256 _price,
        uint256 _productionDate,
        uint256 _shelfLife,
        Measurement _measurement
    ) external accessLevelExact(Role.Vendor) {
        Item memory newItem = Item(
            _name,
            _manufacturer,
            _storageTemperature,
            _price,
            _productionDate,
            _shelfLife,
            _measurement
        );
        items.push(newItem);
        itemToVendor[items.length - 1] = msg.sender;
    }

    function itemList() external view accessLevelExact(Role.Market) returns (Item[] memory) {
        return items;
    }
}
