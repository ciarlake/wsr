// SPDX-License-Identifier: UNKNOWN
pragma solidity ^0.8.7;
import "./appauth.sol";

contract MarketplaceReviews is MarketplaceAuth {
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
        //...
    }
}
