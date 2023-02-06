// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;
pragma experimental ABIEncoderV2;

import "./GovernmentOfficer.sol";


contract FactoryGovernmentOfficer {
    address[] allOfficers;

    function registerOfficer(address _walletAddress, string memory _email, string memory _name, 
    string memory _phoneNumber, string memory _employeeId) public returns (address) {
        GovernmentOfficer newOfficer = new GovernmentOfficer();
        newOfficer.setGovernmentOfficer(_walletAddress, _email, _name, 
        _phoneNumber, _employeeId);
        allOfficers.push(_walletAddress);
        return _walletAddress;
    }

    // function returnString memory() public returns (string memory) {
    //     return "HelloWorld";
    // }

    // function returnInt() public returns (uint) {
    //     return 10;
    // }
}