pragma solidity ^0.4.18;

contract CryptoDoggies{
	
	struct Doggy{
		uint age;
		string name;
		bytes5 dna;
	}

	Doggy doggy1 = Doggy({
		age: 3,
		name: "Cheesecake",
		dna: bytes5(0x000000000)
	});

	Doggy doggy2 = Doggy({
		age: 5,
		name: "Checkers",
		dna: bytes5(0xffffffffff)
	});

	Doggy[] doggies;

	mapping (uint256 => address) private doggyIdToOwner;
	mapping (address => uint256) private numOfDoggies;

	event DoggyCreated(uint256 _id, string _name, uint _age, bytes5 _dna);

	function createDoggy(uint _age, string _name, bytes5 _dna) public {
		Doggy memory _doggy = Doggy({
			age: _age,
			name: _name,
			dna: _dna
		});
		uint256 newDoggyId = doggies.push(_doggy) - 1;
		doggyIdToOwner[newDoggyId] = msg.sender;
		numOfDoggies[msg.sender] = numOfDoggies[msg.sender] + 1;
	
		DoggyCreated(newDoggyId, _name, _age, _dna);
	}
}