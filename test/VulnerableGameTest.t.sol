// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test} from "../lib/forge-std/src/Test.sol";
import {VulnerableGame} from "../src/VulnerableGame.sol";

contract VulnerableGameTest is Test {
    VulnerableGame vulnerableGame;
    address player1 = address(0x123);
    address player2 = address(0x456);

    function setUp() public {
        // Deploy the contract
        vulnerableGame = new VulnerableGame();

        vm.label(player1, "Player 1");
        vm.label(player2, "Player 2");
    }

    function testDepositOneEther() public {
        // Simulate Player 1 sending 1 ether to deposit
        vm.deal(player1, 2 ether); // Give Player 1 1 ether
        vm.prank(player1); // Simulate Player 1 as the caller
        vulnerableGame.deposit{value: 1 ether}();

        // Verify contract balance
        assertEq(address(vulnerableGame).balance, 1 ether, "Contract balance should be 1 ether");
    }

    function testDepositInvalidAmount() public {
        // Simulate Player 1 sending an invalid deposit amount (2 ether)
        vm.deal(player1, 2 ether); // Give Player 1 2 ether
        vm.prank(player1); // Simulate Player 1 as the caller

        // Expect revert with custom error
        vm.expectRevert(VulnerableGame.VulnerableGame__InvalidAmount.selector);
        vulnerableGame.deposit{value: 2 ether}();
    }

    function testWinnerIsSetAfterReachingTarget() public {
        // Simulate deposits by Player 1 to reach the target balance (10 ether)
        vm.deal(player1, 20 ether);
        for (uint256 i = 0; i < 10; i++) {
            vm.prank(player1);
            vulnerableGame.deposit{value: 1 ether}();
        }

        // Check that the contract balance is 10 ether
        assertEq(address(vulnerableGame).balance, 10 ether, "Contract balance should be 10 ether");

        // Check that Player 1 is the winner
        assertEq(vulnerableGame.winner(), player1, "Player 1 should be the winner");
    }

    function testRevertDepositsAfterWinnerIsFound() public {
        // Simulate deposits by Player 1 to reach the target balance (10 ether)
        vm.deal(player1, 10 ether);
        for (uint256 i = 0; i < 10; i++) {
            vm.prank(player1);
            vulnerableGame.deposit{value: 1 ether}();
        }

        // Check that deposits are not allowed after a winner is found
        vm.deal(player2, 1 ether); // Give Player 2 1 ether
        vm.prank(player2); // Simulate Player 2 as the caller
        vm.expectRevert(VulnerableGame.VulnerableGame__WinnerMustWithdraw.selector);
        vulnerableGame.deposit{value: 1 ether}();
    }
}
