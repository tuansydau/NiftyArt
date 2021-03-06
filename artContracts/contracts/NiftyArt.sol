pragma solidity ^0.4.18;

/*
 * AccessControl.sol - Adds acess modifiers to CEO and COO 
 *                 (effectively admin) roles
 * 
 * ERC721.sol - Creates deferred functions that need to be implemented to 
 * 				   meet the ERC721 standard
 *
 * SafeMath.sol - Math free from overflows, mainly for 
 * 	     	       use in payable functions
 */
 
import "./AccessControl.sol";
import "./ERC721.sol";
import "./SafeMath.sol";

contract DetailedERC721 is ERC721 {
	function name() public view returns (string _name);
	function symbol() public view returns (string _symbol);
}

contract NiftyArt is AccessControl, DetailedERC721{
	using SafeMath for uint256;

	event TokenCreated(uint256 tokenId, string name, string link, uint256 price, address owner);
	event TokenSold(uint256 indexed tokenId, string name, string link, uint256 sellingPrice, uint256 newPrice, address indexed oldOwner, address indexed newOwner);

	mapping (uint256 => address) private tokenIdToOwner;
	mapping (uint256 => uint256) private tokenIdToPrice;
	mapping (address => uint256) private ownershipTokenCount;

	// To keep track of whether or not a transaction is approved
	//   in order to allow transfer between ERC721 platforms
	mapping (uint256 => address) private tokenIdToApproved;

	struct Art{
		string name;
		string link;
	}

	Art[] private arts;

	uint256 private startingPrice = 0.01 ether;

	// Acts as a toggle between erc 20 and erc 721 for exchange compatibility
	bool private erc721Enabled = false;

	modifier onlyERC721() {
		require(erc721Enabled);
		_;
	}

	// Token creation and access functions

	// Allows us to deposit into an address as opposed to auctioning it
	function createToken(string _name, string _link, address _owner, uint256 _price) public onlyCLevel {
		require(_owner != address(0));
		require (_price >= startingPrice);

		_createToken(_name, _link, _owner, _price);
	}

	// Creates token and deposits it into the smart contract's address
	function createToken(string _name, string _link) public onlyCLevel {
		_createToken(_name, _link, address(this), startingPrice);
	}

	function _createToken(string _name, string _link, address _owner, uint256 _price) private {
		Art memory _art = Art({
			name: _name,
			link: _link
		});
		uint256 newTokenId = arts.push(_art) - 1;
		tokenIdToPrice[newTokenId] = _price;

		TokenCreated(newTokenId, _name, _link, _price, _owner);
		_transfer(address(0), _owner, newTokenId);
	}

	function getToken(uint256 _tokenId) public view returns (
		string _tokenName,
		string _link,
		uint256 _price,
		uint256 _nextPrice,
		address _owner
	) {
		_tokenName = arts[_tokenId].name;
		_link = arts[_tokenId].link;
		_price = tokenIdToPrice[_tokenId];
		_nextPrice = nextPriceOf(_tokenId);
		_owner = tokenIdToOwner[_tokenId];
	}

	function getAllTokens() public view returns (
		uint256[],
		uint256[],
		address[]
	) {
		uint256 total = totalSupply();
		uint256[] memory prices = new uint256[](total);
		uint256[] memory nextPrices = new uint256[](total);
		address[] memory owners = new address[](total);

		for (uint256 i = 0; i < total; i++){
			prices[i] = tokenIdToPrice[i];
			nextPrices[i] = nextPriceOf(i);
			owners[i] = tokenIdToOwner[i];
		}

		return (prices, nextPrices, owners);
	}

	function tokensOf(address _owner) public view returns (uint256[]) {
		uint256 tokenCount = balanceOf(_owner);
		if (tokenCount == 0){
			return new uint256[](0);
		}
		else{
			uint256[] memory result = new uint256[](tokenCount);
			uint256 total = totalSupply();
			uint256 resultIndex = 0;

			for (uint256 i = 0; i < total; i++){
				if (tokenIdToOwner [i] == _owner){
					result[resultIndex] = i;
					resultIndex++;
				}
			}
			return result;
		}
	}

	function withdrawBalance (address _to, uint256 _amount) public onlyCEO {
		require(_amount <= this.balance);
		
		if (_amount == 0){
			_amount = this.balance;
		}

		if (_to == address(0)){
			ceoAddress.transfer(_amount);
		} else {
			_to.transfer(_amount);
		}
	}

	function purchase (uint256 _tokenId) public payable whenNotPaused {
		address oldOwner = ownerOf(_tokenId);
		address newOwner = msg.sender;
		uint256 sellingPrice = priceOf(_tokenId);

		require(oldOwner != address(0));
		require(newOwner != address(0));
		require(oldOwner != newOwner);
		require(!_isContract(newOwner));
		require(sellingPrice > 0);
		require(msg.value >= sellingPrice);

		_transfer(oldOwner, newOwner, _tokenId);
		tokenIdToPrice[_tokenId] = nextPriceOf(_tokenId);
		TokenSold(
			_tokenId,
			arts[_tokenId].name,
			arts[_tokenId].link,
			sellingPrice,
			priceOf(_tokenId),
			oldOwner,
			newOwner
		);

		uint256 excess = msg.value.sub(sellingPrice);
		uint256 contractCut = sellingPrice.mul(6).div(100);

		if (oldOwner != address(this)) {
			oldOwner.transfer(sellingPrice.sub(contractCut));
		}

		if (excess > 0) {
			newOwner.transfer(excess);
		}
	}

	function purchaseMultiple (uint256[] _tokenIdArray) public payable whenNotPaused {
		uint256 sellingPrice = 0;
		address newOwner = msg.sender;

		require(newOwner != address(0));
		require(!_isContract(newOwner));

		for (uint256 i = 0; i < _tokenIdArray.length; i++){
			sellingPrice = sellingPrice.add(_tokenIdArray[i]);
			require(ownerOf(_tokenIdArray[i]) != address(0));
			require(ownerOf(_tokenIdArray[i]) != newOwner);
		}

		require(sellingPrice > 0);
		require(msg.value >= sellingPrice);


		for (uint256 j = 0; j < _tokenIdArray.length; j++){
			_transfer(ownerOf(_tokenIdArray[j]), newOwner, _tokenIdArray[i]);
			tokenIdToPrice[_tokenIdArray[j]] = nextPriceOf(_tokenIdArray[j]);
			// TokenSold(
			// 	_tokenIdArray[j],
			// 	arts[_tokenIdArray[j]].name,
			// 	arts[_tokenIdArray[j]].link,
			// 	sellingPrice,
			// 	priceOf(_tokenIdArray[j]),
			// 	ownerOf(_tokenIdArray[j]),
			// 	newOwner
			// );
		}

		// uint256 excess = msg.value.sub(sellingPrice);
		// uint256 contractCut = sellingPrice.mul(6).div(100);

		// if (oldOwner != address(this)) {
		// 	oldOwner.transfer(sellingPrice.sub(contractCut));
		// }

		// if (excess > 0) {
		// 	newOwner.transfer(excess);
		// }
	}

	function priceOf(uint256 _tokenId) public view returns (uint256){
		return tokenIdToPrice[_tokenId];
	}

	uint256 private increaseLimit1 = 0.02 ether;
	uint256 private increaseLimit2 = 0.5 ether;
	uint256 private increaseLimit3 = 2.0 ether;
	uint256 private increaseLimit4 = 5.0 ether;
	
	function nextPriceOf(uint256 _tokenId) public view returns (uint256 _nextPrice) {
		uint256 _price = priceOf(_tokenId);
		return _price.mul(6).div(100);
	}

	function enableERC721() public onlyCEO {
		erc721Enabled = true;
	}

	function totalSupply() public view returns (uint256 _totalSupply){
		_totalSupply = arts.length;
	}

	function balanceOf(address _owner) public view returns (uint256 _balance){
		_balance = ownershipTokenCount[_owner];
	}

	function ownerOf(uint256 _tokenId) public view returns (address _owner){
		_owner = tokenIdToOwner[_tokenId];
	}

	function approve(address _to, uint256 _tokenId) public whenNotPaused onlyERC721{
		require(_owns(msg.sender, _tokenId));
		tokenIdToApproved[_tokenId] = _to;
		Approval(msg.sender, _to, _tokenId);
	}

	function transferFrom(address _from, address _to, uint256 _tokenId) public whenNotPaused onlyERC721 {
		require(_to != address(0));
		require(_owns(_from, _tokenId));
		require(_approved(msg.sender, _tokenId));

		_transfer(_from, _to, _tokenId);
	}

	function transfer(address _to, uint256 _tokenId) public whenNotPaused onlyERC721 {
		require(_to != address(0));
		require(_owns(msg.sender, _tokenId));

		_transfer(msg.sender, _to, _tokenId);
	}

	function implementsERC721() public view whenNotPaused returns (bool) {
		return erc721Enabled;
	}

	function takeOwnership(uint256 _tokenId) public whenNotPaused onlyERC721 {
		require(_approved(msg.sender, _tokenId));
		_transfer(tokenIdToOwner[_tokenId], msg.sender, _tokenId);
	}

	function name() public view returns (string _name){
		_name = "Nifty Art"; // Name on etherscan when viewed
	}

	function symbol() public view returns (string _symbol) {
		_symbol = "NTA";
	}

	function _owns(address _claimant, uint256 _tokenId) private view returns (bool) {
		return tokenIdToOwner[_tokenId] == _claimant;
	}

	function _approved(address _to, uint256 _tokenId) private view returns (bool){
		return tokenIdToApproved[_tokenId] == _to;
	}

	function _transfer(address _from, address _to, uint256 _tokenId) private {
		ownershipTokenCount[_to]++;
		tokenIdToOwner[_tokenId] = _to;

		if (_from != address(0)){
			ownershipTokenCount[_from]--;
			delete tokenIdToApproved[_tokenId];
		}

		Transfer(_from, _to, _tokenId);
	}

	function _isContract(address addr) private view returns (bool){
		uint256 size;
		assembly { size := extcodesize(addr) }
		return size > 0;
	}
}
