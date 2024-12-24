// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/**
 * @title VulnerableGame
 * @dev A simple game contract that allows players to deposit 1 ether.
 * The first player to reach a total balance of 10 ether wins the game.
 * The winner can withdraw the total balance of the contract.
 * The contract resets the total balance to 0 after the winner withdraws,
 * effectively resetting the game.
 */
contract VulnerableGame {
    uint256 public target = 10 ether;
    uint256 public constant allowedValue = 1 ether;
    address public winner;

    error VulnerableGame__InvalidAmount();
    error VulnerableGame__WinnerMustWithdraw();
    error VulnerableGame__OnlyWinnerCanWithdraw();
    error VulnerableGame__WithdrawFailed();

    event FoundWinner(address indexed winner);

    /**
     * @dev Deposit 1 ether to the contract.
     * If the total balance reaches the target, the sender becomes the winner
     * for the current round.
     * If a winner is found, no deposits are allowed until the current winner
     * withdraws the total balance.
     */
    function deposit() public payable {
        if (msg.value != allowedValue) {
            revert VulnerableGame__InvalidAmount();
        }

        uint256 balance = address(this).balance;
        if (balance > target) {
            revert VulnerableGame__WinnerMustWithdraw();
        }

        if (balance == target) {
            winner = msg.sender;
        }
    }

    /**
     * @dev Withdraw the total balance of the contract.
     * Only the winner can withdraw the total balance.
     * After the winner withdraws, the total balance is reset to 0.
     */
    function withdraw() public {
        if (msg.sender != winner) {
            revert VulnerableGame__OnlyWinnerCanWithdraw();
        }

        (bool success, ) = msg.sender.call{value: address(this).balance}("");
        if (!success) {
            revert VulnerableGame__WithdrawFailed();
        }

        target = 0;
        winner = address(0);
    }
}
