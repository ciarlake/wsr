// SPDX-License-Identifier: UNKNOWN
pragma solidity ^0.8.7;
import "./apphelper.sol";

contract MarketplaceAuth is MarketplaceHelper {
    mapping (address => bytes32) addressToWord;

    function registerUser(string calldata _name, string calldata _password) external returns (string memory){
        require(
            addressToUser[msg.sender].role == Role.Guest,
            "user already exists"
        );
        string memory word = _genRandomWord(6);
        users.push(msg.sender);
        addressToUser[msg.sender] = User(_name, Role.Customer);
        addressToPassword[msg.sender] = keccak256(abi.encode(_password));
        addressToWord[msg.sender] = keccak256(abi.encode(word));
        return word;
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

    function _genRandomWord(uint _wordLength) internal view returns (string memory) {
        bytes memory alphabet = "abcdefghijklmnopqrstuvwxyz";
        bytes memory word = new bytes(_wordLength);
        for (uint i = 0; i < _wordLength; i++) {
            uint letterIdx = uint(keccak256(abi.encode(block.timestamp, msg.sender, i))) % (alphabet.length - 1);
            word[i] = alphabet[letterIdx];
        }
        return string(word);
    }
}