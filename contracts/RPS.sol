pragma solidity ^0.4.17;

contract RPS {
	// Rock =0, Paper = 1, Scissors = 2
	address user1;
	address user2;
	bytes32 hash1;
	bytes32 hash2;
	int claimed1;
	int claimed2;
	int startTimeForClaim;

	// Check if required minimum amount is present
	modifier checkbalance() {
		require(msg.value>=5);
		_;
	}
	// Check if user is already registered
	modifier isRegistered() {
		require(msg.sender==user1 || msg.sender==user2);
		_;
	}
	// Check if user is already registered
	modifier isNotRegistered() {
		require(msg.sender!=user1 && msg.sender!=user2);
		_;
	}
	// Check if both users have locked their choices, so the game can go to reveal stage
	modifier bothLocked(){
		require( hash1!=0 && hash2!=0);
		_;
	}
	// Check if string is valid
	modifier validChoice(string choice){
		require(keccak256(choice) == keccak256("rock") || keccak256(choice) == keccak256("paper") || keccak256(choice) == keccak256("scissors"));
		_;
	}

	// Initializes all the variables to default values
	function cleanup() public {
	  user1 = address(0);
	  user2 = address(0);
	  hash1 = bytes32(0);
	  hash2 = bytes32(0);
	  claimed1 = 0;
	  claimed2 = 0;
	  startTimeForClaim = 0;
	}
	function register() public isNotRegistered {
		if(user1==0){
			user1 = msg.sender;
		}
		else {
			if(user2==0)
				user2 = msg.sender;
		}
	}
	function lock(string choice,string randStr) public isRegistered validChoice(choice) returns (bool) {
		if(msg.sender ==user1 && hash1==bytes32(0)){
			hash1 = keccak256(keccak256(choice) ^ keccak256(randStr));
			return true;
		}
		if(msg.sender ==user2 && hash2==bytes32(0)){
			hash2 = keccak256(keccak256(choice) ^ keccak256(randStr));
			return true;
		}
		return false;
	}
	function open(string choice,string randStr) public isRegistered bothLocked validChoice(choice) returns (bool) {
		bytes32 tempHash = keccak256(keccak256(choice) ^ keccak256(randStr));
		if(msg.sender ==user1){
			if(tempHash==hash1){
				if(keccak256(choice)==keccak256("rock")){
					claimed1 = 1;
					return true;
				}
				if(keccak256(choice)==keccak256("paper")){
					claimed1 = 2;
					return true;
				}
				if(keccak256(choice)==keccak256("scissors")){
					claimed1 = 3;
					return true;
				}
			}
		}
		if(msg.sender ==user2){
			if(tempHash==hash2){
				if(keccak256(choice)==keccak256("rock")){
					claimed2 = 1;
					return true;
				}
				if(keccak256(choice)==keccak256("paper")){
					claimed2 = 2;
					return true;
				}
				if(keccak256(choice)==keccak256("scissors")){
					claimed2 = 3;
					return true;
				}
			}
		}
		return false;
	}
	// Functions for logs
	function getUser1() public view returns (address) {
	  	return user1;
	}
	function getUser2() public view returns (address) {
	  	return user2;
	}
	function getHash1() public view returns (bytes32) {
	  	return hash1;
	}
	function getHash2() public view returns (bytes32) {
	  	return hash2;
	}
	function getState() public view returns (int) {
	  	if(hash1==bytes32(0) && hash2==bytes32(0))
	  		return 0;
	  	if(hash1==bytes32(0) && hash2!=bytes32(0))
	  		return 1;
	  	if(hash1!=bytes32(0) && hash2==bytes32(0))
	  		return 2;
	  	// Both users have locked at this point of time, return values if claimed
	  	return 4 + (claimed1*10 + claimed2);
	}
}
