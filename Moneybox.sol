//SPDX-License-Identifier: Open Software License 1.0
pragma solidity >=0.8.0;

// Imports
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
// Declare the smart contract
contract MoneyBox {
    // For what do we use the libraries?
    using SafeMath for uint256;
    // Add variables for move money
    uint256 public moneyIn;
    uint256 public moneyOut;
    // Variables for locking the deposit
    uint256 public lockTime;
    // Access
    address public owner;
    // Struct in order to make a deposit
    struct Deposit {
    uint256 _depositId;
    uint256 _amount; // Amount of money to be deposited
    address _from; // Who made the deposit
    uint256 _depositTime; // When the deposit was made?
    uint256 _unlockTime; // When the deposit will be unlocked?
    }
    // Create an array of deposits
    Deposit[] public deposits;
    // Giving initial values of our variables on deployment
    constructor () {
    moneyIn = 0;
    moneyOut = 0;
    lockTime = 2 minutes;
    // The owner of this smart contract will be the deployer
    owner = msg.sender;
    }
    // Create a modifier
    // Functions marked with this modifier can be executed only if the "require" statement is checked
    modifier onlyOwner {
    // If the address that is calling a function is not the owner, an error will be thrown
    require(msg.sender == owner, "You are not the owner of the smart contract!");
    _;
    }
    // Allow the smart contract to receive money
    receive() external payable {
    }
    // Deposit money to the smart contract
    function depositMoney(uint256 _amount) public payable onlyOwner{
    require(msg.value == _amount);
    moneyIn = moneyIn.add(_amount);
    // Get the total of deposits that were made
    uint256 depositId = deposits.length;
    // Create a new struct for the deposit
    Deposit memory newDeposit = Deposit(depositId, msg.value, msg.sender, block.timestamp, block.timestamp.add(lockTime));
    // Push the new deposit to the array
    deposits.push(newDeposit);
    }
    function withdrawMoneyFromDeposit(uint256 _depositId) public {
    require(block.timestamp >= deposits[_depositId]._unlockTime, "Unlock time not reached!");
    moneyOut = moneyOut.add(deposits[_depositId]._amount);
    payable(msg.sender).transfer(deposits[_depositId]._amount);
    }
    // Getter - functions that get a value
    // Get the amount of money deposited
    function getMoneyDeposited() public view returns (uint256) {
    return moneyIn;
    }
    function getMoneyWithdrawn() public view returns (uint256) {
    return moneyOut;
    }
    function getBalanceMoney() public view returns (uint256) {
    return address(this).balance;
    }
    
    // Set the unlock time of deposits to 10 minutes
    function setUnlockTimeToTenMinutes() public onlyOwner {
    lockTime = 10 minutes;
    }
    // Set the unlock time of deposits to 10 days
    function setUnlockTimeToTenDays() public onlyOwner {
    lockTime = 10 days;
    }
    // Set the unlock time of deposits to 5 months
    function setUnlockTimeToTenMonths() public onlyOwner {
    lockTime = 5 * 30 days; // As we don't have "months" in solidity we will use 5 * 30 days
    }
    // Set the unlock time of deposits to 1 year
    function setUnlockTimeToOneYear() public onlyOwner {
    lockTime = 12 * 30 days; // As we don't have "years" in solidity we will use 12 * 30 days
    }
    // Set custom unlock time in minutes
    function setCustomUnlockTimeInMinutes(uint256 _minutes) public onlyOwner {
    uint256 _newLockTime = _minutes * 1 minutes;
    lockTime = _newLockTime;
    }
    // Set new owner
    function setNewOwner(address _newOwner) public onlyOwner {
    owner = _newOwner;
    }
}