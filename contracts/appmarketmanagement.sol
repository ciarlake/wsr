// SPDX-License-Identifier: UNKNOWN
pragma solidity ^0.8.7;
import "./appauth.sol";

contract MarketplaceMarketManagement is MarketplaceAuth{
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
}