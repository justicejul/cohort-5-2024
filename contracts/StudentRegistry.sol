// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

// @title A contract for Student Registry
// @author Justice Julius
contract StudentRegistery {

    // defined empty custom data type
     struct Student{
        address studentAddr;
        uint256 studentId;
        string name;
        uint8 age;
    }

    // Owner of the contract
    address public owner;


    // Events for my Contract
    // Indexed parameters are included in the event's topics, making them searchable and 
    // filterable in the Ethereum logs. However, string and bytes parameters cannot be indexed 
    // because they can be arbitrarily large, making them impractical for indexing
    event addStud(address indexed studentAddr, string name, uint8 age);
    event delStud(address indexed studentAddr);


    // A constructor is a function in smart contract that executes only once throughout the lifetime 
    // of a program.
    constructor () {
        owner = msg.sender;

    }



    // A private dynamic array of students to match the format of the Student struct 
    // this variable is stoered on the storage - on the EVM
    Student[] private students;




    // Mappings for my Student Registery Contract
    mapping(address => Student) public studentsMapping;



    // Mappings for my Contract
    // we can create our own custom modifiers
    modifier onlyOwner() {
        require( owner == msg.sender, "You fraud!!!!");
        _;
    }
    modifier isNotAddressZero () {
        require(msg.sender != address(0), "Invalid Address");
        _;
    }



    //@notice function for creating a student struct and adding it to a list of students 
    //@params this function takes  a student address, name and age as parameters for arguments
    function addStudent(address _studentAddr, string memory _name, uint8 _age) onlyOwner public  {
        
        // without the bytes function we won't have access to te characters of a string
        require( bytes(_name).length > 0, "Name cannot be blank");
        require(_age >= 18, "The student have to be more than 18");
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


    // @notice function for getting student
    // @return It returns student by student ID argument
    function getStudent(uint8 _studentId) public isNotAddressZero view returns (Student memory) {
        return students[_studentId - 1];
    }



    // @params takes students address as parameters for arguments 
    // @notice function for fetting student from mapping
    // @return returns student by address argument
    function getStudentFromMapping(address _studentAddr) public view returns (Student memory){
       return studentsMapping[_studentAddr]; 
    }



    // @params, this function takes student ID, name, age and address as parameters for arguments
    // @notice function for updating student info using student ID
    function updateStudent(uint8 _studentId, string memory _name, uint8 _age, address _studentAddr) public {
        require( _age >= 18, "Age should not be less than 18");
        
        Student storage currentStudent = students[_studentId - 1];
        currentStudent.name = _name;
        currentStudent.age = _age;
        currentStudent.studentAddr = _studentAddr;
        
    }
     

    //@params This function takes in student address as parameters for arguments
    //@dev This function has event function which fires after this function has been executed
    function deleteStudent(address _studentAddr) public onlyOwner  isNotAddressZero{
        require(studentsMapping[_studentAddr].studentAddr != address(0), "Student does not exist");
        // delete studentsMapping[_studentAddr];

        Student memory student = Student({
            studentAddr: address(0),
            name: "",
            age: 0,
            studentId: 0
        });

        studentsMapping[_studentAddr] = student;

        emit delStud(_studentAddr);

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


