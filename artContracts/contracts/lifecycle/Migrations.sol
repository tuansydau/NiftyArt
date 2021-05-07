pragma solidity ^0.4.18;

import "zeppelin-solidity/contracts/ownership/Ownable.sol";

/**
 * @title Migrations
 * @dev This truffle contract gives ownership to whoever deploys the contract.
 */

contract Migrations is Ownable {
	uint256 public lastCompletedMigration;

	function setCompleted(uint256 completed) public onlyOwner {
		lastCompletedMigration = completed;
	}

	function upgrade(address newAddress) public onlyOwner {
		Migrations upgraded = Migrations(newAddress);
		upgraded.setCompleted(lastCompletedMigration);
	}
}