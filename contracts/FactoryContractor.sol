// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import "./Contractor.sol";

contract FactoryContractor {
    address[] public allContractors;
    
    //----do not use---- adds the new contract to same byte code--useless shit.
    function registerNewContractor(address _walletAddress, string memory _email, string memory _name,
    string memory _phoneNumber, string memory _panNumber, string memory _gstNumber) public returns (bool) {
        Contractor contractor = new Contractor();
        contractor.setContractor(_walletAddress, _email, _name,
        _phoneNumber, _panNumber, _gstNumber);
        allContractors.push(_walletAddress);
        return true;
    }
}