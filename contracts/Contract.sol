// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;
pragma experimental ABIEncoderV2;


contract Contract {   
    address public governmentOfficerAddress;
    address public contractorAddress;
    string tenderId;
    uint public creationDate;
    uint public completionDate;
    string[] public constraints;
    uint finalQuotationAmount;
    //address public specialOfficerAddress;

    bool public governmentOfficerVerified;
    //bool public specialOfficerVerified;

    string public contractName;

    mapping (uint=>Task) private taskIndexMapping;
    
    struct Task {
        string description;
        uint deadlineTime;
        uint amount; 
        TaskStatus status;
        uint completionTime; 
    }

    enum TaskStatus {
        pending,
        reportedComplete,
        partiallyVerified,
        complete,
        contractorPaid
    }

    Task[] public tasks;

    modifier onlyGovernmentOfficer {
        require(msg.sender != governmentOfficerAddress, "WRONG GOVERNEMT OFFICER!");
        _;
    }

    modifier onlyContractor {
        require(msg.sender != contractorAddress, "WRONG CONTACTOR");
        _;
    }

    // modifier onlySpecialOfficer {
    //     if (msg.sender != specialOfficerAddress) {
    //         revert();
    //         _;
    //     }
    // }
    
    function setContractBasic (
        address _governmentOfficerAddress, 
        address _contractorAddress, 
        string memory _tenderId,
        uint _completionDate,
        string[] memory _constraints
        ) public {
        governmentOfficerAddress = _governmentOfficerAddress;
        contractorAddress = _contractorAddress;
        tenderId = _tenderId;
        constraints = _constraints;
        creationDate = block.timestamp;
        completionDate = _completionDate;
    }


// string description;
//         uint deadlineTime;
//         uint amount; 
//         TaskStatus status;
//         uint completionTime; 
    function setContractAdvanced (
        string memory  _contractName, 
        uint _finalQuotationAmount,
        string[] memory  _taskDescription, 
        uint[] memory  _deadlineForEachTask, 
        uint[] memory  _amountForEachTask) public {
        contractName = _contractName;
        finalQuotationAmount = _finalQuotationAmount;
        uint totalAmount = 0;
        
        for (uint i=0; i < _taskDescription.length; i++) {
            Task memory task =  Task({description:_taskDescription[i], deadlineTime: _deadlineForEachTask[i], amount: _amountForEachTask[i], status: TaskStatus.pending, completionTime: block.timestamp + _deadlineForEachTask[i]});
            totalAmount += _amountForEachTask[i];
            
            taskIndexMapping[i] = task;
            tasks.push(task);
        }
        require(totalAmount >= _finalQuotationAmount, "Final Quation Amount EXCEEDS!");
        //ContractDeployed();
    }

    function getContractBasic() public view returns (string memory , address, address, string memory,
    uint, uint) {
        return (contractName, governmentOfficerAddress, contractorAddress, tenderId,
        creationDate, completionDate);
    }

    function getContractAdvanced() public view returns (string memory, uint, string[] memory) {
        return (contractName, finalQuotationAmount, 
        constraints);
    }

    function getContractName() public view returns (string memory) {
        return contractName;
    }

    function getCompletionDate() public view returns (uint) {
        return completionDate;
    }

    function getNumberOfTasks() public view returns (uint) {
        return tasks.length;
    }

    function getTask(uint256 index) public view returns (string memory, uint, uint, TaskStatus, uint) {
        return (tasks[index].description, tasks[index].deadlineTime, tasks[index].amount,
        tasks[index].status, tasks[index].completionTime);
    }

    function taskCompletedByContractor(uint _taskIndex) public onlyContractor {
        if (_taskIndex >= tasks.length) revert();
        Task storage task = tasks[_taskIndex];

        if (msg.sender != contractorAddress) revert();
        if (task.status != TaskStatus.pending) revert();
        if (block.timestamp > task.deadlineTime) revert();
        task.status = TaskStatus.reportedComplete;
        task.completionTime = block.timestamp;
        //eventToFire
    }

    function verifyTask(uint _taskIndex) public onlyGovernmentOfficer returns (bool) {
        if (_taskIndex >= tasks.length) revert();
        Task storage task = tasks[_taskIndex];

        if (task.status != TaskStatus.reportedComplete) revert();
        if (msg.sender == governmentOfficerAddress) {
            governmentOfficerVerified = true;
            task.status = TaskStatus.complete;
            return true;
        // }else if (msg.sender == specialOfficerAddress) {
        //     specialOfficerVerified = true;
        //     task.status = TaskStatus.partiallyVerified;
        // }
        }else {
            revert();
        }

        // if (governmentOfficerVerified && specialOfficerVerified) {
        //     task.status = TaskStatus.complete;
        // }
    }

    function withdrawForTask(uint _taskIndex) public payable onlyContractor returns (bool) {
        if (_taskIndex >= tasks.length) revert();
        Task storage task = tasks[_taskIndex];

        if (msg.sender != contractorAddress) revert();
        if (task.status != TaskStatus.complete) revert();

        uint amount = task.amount*(1 ether);
        task.status = TaskStatus.contractorPaid;
        payable(msg.sender).transfer(amount);
        return true;
    }
}
