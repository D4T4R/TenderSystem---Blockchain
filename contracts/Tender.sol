// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;
pragma experimental ABIEncoderV2;


contract Tender {   
    address public governmentOfficerAddress;
    string public tenderName; 
    string public tenderId;
    //string public organisationChain;
    //string public tenderRefNum;
    //string public tenderType;
    //string public tenderCategory;
    uint256 public bidSubmissionClosingDate;
    uint256 public bidOpeningDate;
    uint256 public covers;
    string[] public clauses;
    string[] public taskName;
    uint256[] public taskDays;
    string[] public constraints;
    uint256 finalTenderAmount;

    struct ContractorProposal {
        address contractorAddress;
        string[] quotationClause;
        uint256[] quotationAmount;
        uint256 proposalAmount;
        //mapping(string=>uint) quotations;
        string[] constraintDocuments;
        ProposalStatus status;
    }

    enum ProposalStatus {
        verified,
        unverified,
        rejected
    }

    ContractorProposal[] public allContractorProposals;
    mapping (address => ProposalStatus) isProposalVerified;

    function getTenderName() public view returns (string memory) {
        return tenderName;
    }

    function setTenderBasic(address _governmentOfficerAddress, string memory  _tenderName, string memory  _tenderId, 
    //string _organisationChain, string _tenderRefNum,
    uint256 _bidSubmissionClosingDate, uint256 _bidOpeningDate, uint256 _covers) public {
        governmentOfficerAddress = _governmentOfficerAddress;   
        tenderName = _tenderName;
        tenderId = _tenderId;
        //organisationChain = _organisationChain;
        //tenderRefNum = _tenderRefNum;
        // tenderType = _tenderType;
        // tenderCategory = _tenderCategory;
        bidSubmissionClosingDate = _bidSubmissionClosingDate;
        bidOpeningDate = _bidOpeningDate;
        covers = _covers;
        finalTenderAmount = 0;
    }
    
    function setTenderAdvanced(string[] memory  _clauses,
    string[] memory _taskName, uint256[] memory  _taskDays,
    string[] memory _constraints) public {
        clauses = _clauses;
        taskName = _taskName;
        taskDays = _taskDays;
        constraints = _constraints;
    }

    function getTenderBasic() public view returns (address, string memory, string memory,
    uint, uint, uint) {
        return (governmentOfficerAddress, tenderName, tenderId, 
        bidSubmissionClosingDate, bidOpeningDate, covers);
    }

    function getTenderAdvanced() public view returns (string[] memory, string[] memory, uint256[] memory, string[] memory) {
        return (clauses, taskName, taskDays, constraints );
    }

    function bid(address _contractorAddress,
    string[] memory _quotationClause, uint256[] memory _quotationAmount, string[] memory  _constraintDocuments) public returns (bool) {
        uint length = allContractorProposals.length;
        ContractorProposal storage temp = allContractorProposals[length];
        temp.contractorAddress = _contractorAddress;
        for (uint i=0; i < _quotationClause.length; i++) {
            temp.quotationClause[i] = _quotationClause[i];
            temp.quotationAmount[i] = _quotationAmount[i];
            temp.proposalAmount += _quotationAmount[i];
        }
        for (uint j=0; j < _constraintDocuments.length; j++) {
            temp.constraintDocuments[j] = _constraintDocuments[j];
        }
        temp.status = ProposalStatus.unverified;
        return true;
    }  

    function getBiddindCloseDate() public view returns (uint256) {
        return bidSubmissionClosingDate;
    }

    function getProposalCount() public view returns (uint256) {
        return allContractorProposals.length;
    }

    function setTenderAmount(uint256 amount) public {
        if (amount != 0 && finalTenderAmount == 0)
            finalTenderAmount = amount;
    }
string[][] tempDocuments;
    function getProposalsToVerify(uint index) public returns (string[] memory, string[][] memory, address) {
        //loop at web3
        address tempAddresses;
        if (allContractorProposals[index].status == ProposalStatus.unverified) {
            tempDocuments.push(allContractorProposals[index].constraintDocuments);
            tempAddresses = allContractorProposals[index].contractorAddress;
        }
        return (constraints, tempDocuments, tempAddresses);
    }

    function verifyProposal(address contractorAddress) public {
        isProposalVerified[contractorAddress] = ProposalStatus.verified;
    }

    function rejectProposal(address contractorAddress) public {
        isProposalVerified[contractorAddress] = ProposalStatus.rejected;
    }

    function getProposal(uint256 index) public view returns (address, uint256, string[] memory, uint256[] memory, ProposalStatus) {
        if (index > allContractorProposals.length) revert();
        return (allContractorProposals[index].contractorAddress, 
        allContractorProposals[index].proposalAmount, allContractorProposals[index].quotationClause,
        allContractorProposals[index].quotationAmount, allContractorProposals[index].status);
    }

    function getVerifiedProposals(uint index) public returns (string[] memory, string[][] memory, address, uint[] memory) {
        //loop at web3
        address tempAddresses;
        uint[] memory tempAmount;
        if (allContractorProposals[index].status == ProposalStatus.verified) {
            tempDocuments.push(allContractorProposals[index].constraintDocuments);
            tempAddresses = allContractorProposals[index].contractorAddress;
            tempAmount = allContractorProposals[index].quotationAmount;
        }
        return (constraints, tempDocuments, tempAddresses, tempAmount);
    }
    
}