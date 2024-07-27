// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract StudentRegistry {
    //custom data type
    struct Student {
        address studentAddr;
        string name;
        uint256 studentId;
        uint8 age;
    }


    address public  owner;


    constructor () {
        owner = msg.sender;
    }

    //dynamic array of students
    Student[] private students;

    function addStudent(
        address _studentAddr,
        string memory _name,
        uint8 _age
    ) public {
        require(owner == msg.sender, "You are not authorized");
        uint256 _studentId = students.length + 1;
        Student memory student = Student({
            studentAddr: _studentAddr,
            name: _name,
            age: _age,
            studentId: _studentId
        });

        students.push(student);
    }

    function getStudent(uint8 _studentId) public view returns (Student memory) {
        return students[_studentId - 1];
    }



}
