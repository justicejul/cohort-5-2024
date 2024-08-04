// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;
import "./Ownable.sol";
import "./Student.sol";


contract StudentRegistry is Ownable {
    //custom erros
    error NameIsEmpty();
    error UnderAge(uint8 age, uint8 expectedAge);

    //custom data type
   
  
    //dynamic array of students
    Student[] private students;




    // Mappings for my Student Registery Contract
    mapping(address => Student) public studentsMapping;


    modifier isNotAddressZero() {
        require(msg.sender != address(0), "Invalid Address");
        _;
    }

    function addStudent(
        address _studentAddr,
        string memory _name,
        uint8 _age
    ) public  isNotAddressZero {
        if (bytes(_name).length == 0) {
            revert NameIsEmpty();
        }

        if (_age < 18) {
            revert UnderAge({age: _age, expectedAge: 18});
        }

        uint256 _studentId = students.length + 1;
        // A variable is defined to match the array format and datatype
        Student memory student = Student({
            studentAddr: _studentAddr,
            name: _name,
            age: _age,
            studentId: _studentId
        });
        students.push(student);

        // add student to Studentmapping
        studentsMapping[_studentAddr] = student;
        emit addStud(_studentAddr, _name, _age);
    }

    function getStudent(uint8 _studentId)
        public
        view
        isNotAddressZero
        returns (Student memory)
    {
        return students[_studentId - 1];
    }

    function getStudentFromMapping(address _studentAddr)
        public
        view
        isNotAddressZero
        returns (Student memory)
    {
        return studentsMapping[_studentAddr];
    }

    function deleteStudent(address _studentAddr)
        public
        onlyOwner
        isNotAddressZero
    {
        require(
            studentsMapping[_studentAddr].studentAddr != address(0),
            "Student does not exist"
        );

        // delete studentsMapping[_studentAddr];

        Student memory student = Student({
            studentAddr: address(0),
            name: "",
            age: 0,
            studentId: 0
        });

        studentsMapping[_studentAddr] = student;
    }


    function modifyOwner(address _newOwner) public {
        changeOwner(_newOwner);
    }



    // @notice, function for updating student mapping 
    // @params, address, name, and age are the parameter for this function
    function updateStudentMapping(address _studentAddr, string memory _name, uint8 _age) onlyOwner public  {
        Student storage currentStudent = studentsMapping[_studentAddr];
        currentStudent.name = _name;
        currentStudent.age = _age;
        currentStudent.studentAddr = _studentAddr;
        
     

} 
}


