// SPDX-License-Identifier: UNKNOWN
pragma solidity ^0.8.7;
import "./apphelper.sol";

contract MarketplaceUserManagement is MarketplaceHelper{
    struct VendorRequest {
        address sender;
        address market;
    }

    VendorRequest[] internal vendorRequests;

    function requestVendor(address _market) external accessLevelExact(Role.Customer) {
        for (uint i = 0; i < vendorRequests.length; i++) {
            require(
                vendorRequests[i].sender != _market,
                "vendor request from this user already exists"
            );
        }
        vendorRequests.push(VendorRequest(msg.sender, _market));
    }
    function listVendorRequests() external view accessLevelExact(Role.SystemAdministrator) returns(VendorRequest[] memory) {
        return vendorRequests;
    }
    function approveVendor(address _user) external accessLevelExact(Role.SystemAdministrator) {
        for (uint i = 0; i < vendorRequests.length; i++) {
            if (vendorRequests[i].sender == _user) {
                addressToUser[_user].role = Role.Vendor;
                vendorToMarket[_user] = vendorRequests[i].market;
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
        delete vendorToMarket[_vendor];
    }
    function _deleteVendorRequest(uint _idx) internal {
        vendorRequests[_idx] = vendorRequests[vendorRequests.length - 1];
        delete vendorRequests[vendorRequests.length - 1]; 
    }
}