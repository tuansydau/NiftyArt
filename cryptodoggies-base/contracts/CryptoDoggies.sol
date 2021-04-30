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

	function _createDoggy(uint _age, string _name, bytes5 dna) private {
		Doggy memory _doggy = Doggy({
			age: _age,
			name: _name,
			dna: _dna,
		});
		uint256 newdoggyId = doggies.push(_doggy) - 1;
	}
}