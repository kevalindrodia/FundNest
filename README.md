# FundNest: DeFi CrowdFunding

This project showcases the FundNest crowdfunding platform built on Hardhat. It includes the main crowdfunding contract, tests for contract functionality, and deployment scripts for managing funding operations.


```shell
# Compile the smart contracts
npx hardhat compile

# Run a specific test file
npx hardhat test ./test/FundNest.test.js

# Deploy the contract to a local network
npx hardhat run scripts/deploy.js --network localhost

# Deploy the contract to a specified network (e.g., sepolia)
npx hardhat run scripts/deploy.js --network sepolia

# Verify a contract on Etherscan (you'll need to set up Etherscan API keys)
npx hardhat verify --network sepolia <THE_CONTRACT_ADDRESS>

# Generate a gas report for your tests
REPORT_GAS=true npx hardhat test

# Run a local Ethereum node for testing
npx hardhat node

# Create a new Hardhat project
npx hardhat init
```
