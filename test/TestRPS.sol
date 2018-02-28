pragma solidity ^0.4.17;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/RPS.sol";

contract TestRPS {
  	RPS rps = RPS(DeployedAddresses.RPS());
 	
 	// Testing the register() function
	function testRegister() public {

		rps.cleanup();
	  	rps.register();
	  	address user1 = rps.getUser1();
	  	address user2 = rps.getUser2();
	  	address expected = this;

	  	Assert.equal(user1, expected, "Registered user is not same as this user");
	  	Assert.equal(user2, 0, "User2 should be equal to zero");
	}
	// Testing the getUser1() function
	function testCleanUp() public {
		rps.cleanup();
	  	address user1 = rps.getUser1();
	  	address expected = 0;
	  	Assert.equal(user1, expected, "After cleaup, user1 should be zero");
	  	
	  	address user2 = rps.getUser2();
	  	Assert.equal(user2, expected, "Registered user is not same as this user");
	}
	// Testing the getUser1() function
	function testUser2() public {
	  
	}
	
	function testLock() public {
		rps.register();
	  rps.lock("paper","manish");
	  //bytes32 hash1 = rps.getHash1()
	  //bytes32 hash2 = keccak256(keccak256(choice) ^ keccak256(randStr));
	  int s1 = 3;
	  int s2 = 3;
	  Assert.equal(s1, s2, "Successfully locked");
	  int state = rps.getState();
	  Assert.equal(state, 2, "State should be modified to 2 after locking input of user1");
	}
	 
	function testLockedvalue() public{
		bytes32 hash1 = rps.getHash1();
	  	bytes32 hash2 = keccak256(keccak256("paper") ^ keccak256("manish"));
	  	Assert.equal(hash1, hash2, "Locked value is not same as retrieved valuex");
	}

}