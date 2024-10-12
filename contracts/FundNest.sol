// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract Crowdfunding is Ownable {
    using SafeMath for uint256;

    struct Contributor {
        address wallet;
        string name;
        uint256 amount;
    }

    mapping(address => Contributor) public contributors;
    address[] public contributorAddresses;
    uint256 public totalFunds;
    uint256 public fundingDeadline;
    bool public fundingActive;

    event FundingStarted(uint256 duration);
    event FundingStopped();
    event FundReceived(address indexed contributor, uint256 amount);
    event FundsWithdrawn(address indexed recipient, uint256 amount);

    modifier onlyWhenActive() {
        require(fundingActive, "Funding is not active");
        _;
    }

    modifier onlyWhenInactive() {
        require(!fundingActive, "Funding is still active");
        _;
    }

    constructor() {
        fundingActive = false;
    }

    function addFunding(string memory name) external payable onlyWhenActive {
        require(msg.value > 0, "Must send some ether");
        
        if (contributors[msg.sender].wallet == address(0)) {
            contributors[msg.sender] = Contributor(msg.sender, name, msg.value);
            contributorAddresses.push(msg.sender);
        } else {
            contributors[msg.sender].amount = contributors[msg.sender].amount.add(msg.value);
        }

        totalFunds = totalFunds.add(msg.value);
        emit FundReceived(msg.sender, msg.value);
    }

    function startFunding(uint256 duration) external onlyOwner onlyWhenInactive {
        fundingActive = true;
        fundingDeadline = block.timestamp.add(duration);
        emit FundingStarted(duration);
    }

    function stopFunding() external onlyOwner onlyWhenActive {
        fundingActive = false;
        emit FundingStopped();
    }

    function withdrawNowStopFunding() external onlyOwner onlyWhenActive {
        require(block.timestamp > fundingDeadline, "Funding period not yet ended");
        fundingActive = false;

        // Transfer the total funds to the owner's wallet
        uint256 amount = totalFunds;
        totalFunds = 0;

        payable(owner()).transfer(amount);
        emit FundsWithdrawn(owner(), amount);
    }

    function withdrawFunds() external onlyWhenInactive {
        require(block.timestamp > fundingDeadline, "Funding period not yet ended");
        require(contributors[msg.sender].amount > 0, "No funds to withdraw");

        uint256 amount = contributors[msg.sender].amount;
        contributors[msg.sender].amount = 0; // Reset their contribution to zero

        payable(msg.sender).transfer(amount);
        emit FundsWithdrawn(msg.sender, amount);
    }

    function getContributorInfo(address contributor) external view returns (string memory, uint256) {
        return (contributors[contributor].name, contributors[contributor].amount);
    }

    function getTotalFunds() external view returns (uint256) {
        return totalFunds;
    }
}