# VulnerableGame - Demonstrating a Smart Contract Exploit

This repository showcases a vulnerability in a Solidity smart contract, `VulnerableGame`, and demonstrates how it can be exploited using a `SelfDestructExploit` contract.

## Overview

- **VulnerableGame**: A game where players deposit 1 ether. The first player to make the contract balance reach 10 ether wins and can withdraw all funds. The game is then reset and can start over.
- **SelfDestructExploit**: A malicious contract that uses `selfdestruct` to forcibly send ether to the `VulnerableGame` contract, bypassing its logic, making the game unplayable and the funds unretrievable.

## Problem

The `VulnerableGame` contract is vulnerable because:
1. It relies on `address(this).balance` for game logic.
2. It doesn’t prevent nor handle unexpected ether transfers.

### Exploit

The `SelfDestructExploit` contract can forcibly send ether using `selfdestruct`, causing:
- The game to reach the target balance unexpectedly.
- Potentially locking or misdirecting funds.

---

## How to Test the Vulnerability

### Prerequisites

- [Foundry](https://book.getfoundry.sh/)
- Solidity compiler (v0.8.x).

### Steps

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/nightowlish/selfdestruct-attack.git
   cd selfdestruct-attack
   ```
2. **Compile the Contracts**:
   Use Foundry to compile the smart contracts:
   ```bash
   forge install
   forge build
   ```
3. **Run the Exploit**:
    
   ```bash
   forge test --match-test testExploit -vvv
   ```
