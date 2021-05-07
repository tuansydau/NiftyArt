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

contract DeatiledERC721 is ERC721 {
	function name() public view returns (string _name);
	function symbol() public view returns (string _symbol);

}

contract CryptoDoggies is AccessControl, DetailedERC721{
	using SafeMath for uint256;
}