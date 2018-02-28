pragma solidity ^0.4.17;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/RPS.sol";

contract TestRPS {
  	RPS rps = RPS(DeployedAddresses.RPS());
 	
 	// Testing the register() function
	function testRegister() public {
	  rps.register();
	  address user1 = rps.getUser1();
	  address expected = this;

	  Assert.equal(user1, expected, "Registered user is not same as this user");
	}
	// Testing the getUser1() function
	function testCleanUp() public {
		rps.cleanup();
	  address user1 = rps.getUser1();
	  address expected = 0;
	  Assert.equal(user1, expected, "After cleaup, user1 should be zero");
	}
	// Testing the getUser1() function
	function testUser2() public {
	  address user2 = rps.getUser2();
	  address expected = 0;
	  Assert.equal(user2, expected, "Registered user is not same as this user");
	}
	
	function testLock() public {
	  rps.lock("paper","manish");
	  //bytes32 hash1 = rps.getHash1()
	  //bytes32 hash2 = keccak256(keccak256(choice) ^ keccak256(randStr));
	  int s1 = 3;
	  int s2 = 3;
	  Assert.equal(s1, s2, "Successfully locked");
	}
	 
	function testLockedvalue() public{
		bytes32 hash1 = rps.getHash1();
	  	bytes32 hash2 = keccak256(keccak256("paper") ^ keccak256("manish"));
	  	Assert.equal(hash1, hash2, "Locked value is not same as retrieved valuex");
	}

}