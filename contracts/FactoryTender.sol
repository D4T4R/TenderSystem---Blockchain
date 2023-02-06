// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;
pragma experimental ABIEncoderV2;

import "./Tender.sol";


contract FactoryTender {
    Tender[] allTenders;

    function createTender(address governmentOfficerAddress, string memory tenderName, string memory tenderId, 
    //string organisationChain, string tenderRefNum,
    uint bidSubmissionClosingDate, uint bidOpeningDate, uint covers, string[] memory clauses,
    string[] memory taskName, uint[] memory taskDays, 
    string[] memory constraints) public returns (Tender) {
        Tender newTender = new Tender();
        newTender.setTenderBasic(governmentOfficerAddress, tenderName, tenderId, 
        //organisationChain, tenderRefNum,
        bidSubmissionClosingDate, bidOpeningDate, covers);
        newTender.setTenderAdvanced(clauses,
        taskName, taskDays, 
        constraints);
        allTenders.push(newTender);
        return newTender;
    }
}