// SPDX-License-Identifier: UNKNOWN
pragma solidity ^0.8.7;
import "./appauth.sol";

contract MarketplaceMarketManagement is MarketplaceAuth{
    struct MarketRegistrationRequest {
        address account;
        string city;
    }

    event MarketRegistrationRequestCreated(address _account, string _name, string _city);
    event MarketApproved(address _account, string _name, string _city);
    event MarketDenied(address _account);

    MarketRegistrationRequest[] private mrRequests;

    function requestMarketplaceRegistration(string memory _city) external accessLevelExact(Role.Customer){
        mrRequests.push(MarketRegistrationRequest(msg.sender, _city));
        emit MarketRegistrationRequestCreated(msg.sender, addressToUser[msg.sender].name, _city);
    }
    function getMRRequests() external view accessLevel(Role.SystemAdministrator) returns (MarketRegistrationRequest[] memory) {
        return mrRequests;
    }
    function approveMarket(address _account) external accessLevel(Role.SystemAdministrator) {
        for (uint i = 0; i < mrRequests.length; i++) {
            if (mrRequests[i].account == _account) {
                _approveMarket(i);
            }
        }
        revert("address not found");
    }
    function approveMarketAt(uint _idx) external accessLevel(Role.SystemAdministrator) {
        _approveMarket(_idx);
    }
    function denyMarket(address _account) external accessLevel(Role.SystemAdministrator) {
        for (uint i = 0; i < mrRequests.length; i++) {
            if (mrRequests[i].account == _account) {
                _denyMarket(i);
            }
        }
        revert("address not found");
    }
    function denyMarketAt(uint _idx) external accessLevel(Role.SystemAdministrator) {
        _denyMarket(_idx);
    }
    function _denyMarket(uint _idx) internal {
        emit MarketDenied(mrRequests[_idx].account);
        _deleteMRRequest(_idx);
        return;
    }
    function _approveMarket(uint _idx) internal {
        Market memory market = Market(mrRequests[_idx].city);
        //TODO:Implement new markets taking out a loan of 1000ETH from the Bank account
        addressToMarket[mrRequests[_idx].account] = market;
        emit MarketApproved(mrRequests[_idx].account, addressToUser[mrRequests[_idx].account].name, mrRequests[_idx].city);
        _deleteMRRequest(_idx);
        return;
    }
    function _deleteMRRequest(uint _idx) private {
        delete mrRequests[_idx];
        mrRequests[_idx] = mrRequests[mrRequests.length - 1];
        delete mrRequests[mrRequests.length - 1];
    }
    function _loanOutMoneyTo(address _account) external payable {
        
    }

}