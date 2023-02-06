// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;
pragma experimental ABIEncoderV2;


contract ContractRepo {
    address[] public contractAddress;
    address[] public completedContracts; //used for quick access to Completed Contracts

    enum ContractStatus {
        onGoing,
        complete
    }

    mapping (address=>ContractStatus) public contractMapping;


    function addToContracts(address contractToAppend) public returns (bool) {
        contractAddress.push(contractToAppend);
        contractMapping[contractToAppend] = ContractStatus.onGoing;
        return true;
    }

    function getAllContracts() public view returns (address[] memory) {
        return contractAddress;
    }

    function getContractCount() public view returns (uint256) {
        return contractAddress.length;
    }

    function getOngoingContracts(uint256 index) public view returns (address) {
        //loop at web3
        if (index > contractAddress.length) revert();
        if (contractMapping[contractAddress[index]] == ContractStatus.onGoing) {
            return contractAddress[index]; 
        }
        revert();
    }

    function getCompletedContracts() public view returns (address[] memory) {
        return completedContracts;
    }

    function updateContractStatusToComplete(address _contractAddress) public {
        contractMapping[_contractAddress] = ContractStatus.complete;
        completedContracts.push(_contractAddress);
    }

}