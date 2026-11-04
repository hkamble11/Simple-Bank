// SPDX-License-Identifier:MIT

pragma solidity ^0.8.27;

contract Funding {
    // State Varibales  
    address public Owner;
    uint256 private total;
    uint256 private totalContributions;
    // Constructor 
    constructor() {
        Owner = msg.sender;
    }
    // Events
    event Deposit(address indexed _user, uint _crypto);
    event Withdrawal(address indexed _user, uint _crypto);
    // Mapping and Struct
    struct Person {
        string name;
        uint crypto;
    }
    mapping(address => Person) public personData;
    mapping(address => bool) public contributer;

    // Deposit the crypto
    function deposit(string memory _name) public payable{
        require(msg.sender != address(0), "Invalid addres");
        require(msg.value > 0, "Amount Should be Greater than zero");
        contributer[msg.sender] = true;
        personData[msg.sender].name = _name;

        personData[msg.sender].crypto += msg.value;
        totalContributions += msg.value;
        total += msg.value;
        emit Deposit(msg.sender, msg.value);
    }

    // Withdrawal the crypto 
    function withdraw(uint _crypto) public  {
        // Check
        require(_crypto > 0, "Amount must be Greatet then Zero");
        require(personData[msg.sender].crypto >= _crypto,"Insufficient personal balance");
        require(address(this).balance >= _crypto, "Insufficient contract balance");
        require(contributer[msg.sender], "You are not a contributor");
        // Effect 
        personData[msg.sender].crypto -= _crypto;
        total -= _crypto;
        totalContributions -= _crypto;
        // Interaction 
        (bool success,) = payable(msg.sender).call{value: _crypto}("");
        require(success, "Transfer is failed");
        emit Withdrawal(msg.sender, _crypto);
    }
    // Total Balance are Deposite by the people 
   function totalDeposit() public view returns (uint256) {
    return totalContributions;
   }
    // Total Balance in the Contract
    function totalContract() public view returns(uint) {
        return address(this).balance;
    }
    // Receive Function
    receive() external payable {
        require(msg.sender != address(0), "Invalid addres");
        require(msg.value > 0, "Amount ahoud be greate then zero");
        total += msg.value;
    }
    // Fallback Function
     fallback() external payable {
        require(msg.sender != address(0), "Invalid addres");
        require(msg.value > 0, "Amount ahoud be greate then zero");
        total += msg.value;
    }

}