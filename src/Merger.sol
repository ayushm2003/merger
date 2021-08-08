// SPDX-License-Identifier: MIT
pragma solidity 0.5.16;

import "./Gov/GovERC20.sol";
import "./Gov/GovernorAlpha.sol";
import "./Gov/Timelock.sol";
import "./Gov/SafeMath.sol";

contract Merger {
	// Address of the ERC20 token of one of the projects
	address public token1;
	// Address of the ERC20 token of the other project
	address public token2;

	// Amount of newTokens to mint for 1 token of token1
	// Eg. - for every 10 newtokens per token1, rate = 10e18
	uint256 public rate1;
	// Amount of newTokens to mint for 1 token of token2
	uint256 public rate2;

	// Address of new token
	address public newToken;
	// Address of timelock
	address public timelock;
	// Address of governor alpha
	address public govAlpha;

	// EVENTS
	event Merge(address indexed token, address indexed holder, uint256 amount);

	constructor(
		address _token1,
		address _token2,
		uint256 _rate1,
		uint256 _rate2,
		string memory _name,  // Name of the new token
		string memory _symbol,  // Symbol of the new token
		uint256 _timelockDelay,
		string memory _govName) public {

		token1 = _token1;
		token2 = _token2;
		rate1 = _rate1;
		rate2 = _rate2;

		// Deploy new ERC20
		Token token = new Token(address(this), _name, _symbol);
		newToken = address(token);

		// Deploy timelock
		Timelock timelockDeploy = new Timelock(address(this), _timelockDelay);
		timelock = address(timelockDeploy);

		// Deploy governor alpha
		GovernorAlpha alpha = new GovernorAlpha(newToken, timelock, _govName);
		govAlpha = address(alpha);
	}

	function swapTokens(address _token) public {
		require(_token == token1 || _token == token2, "Invalid token address");

		uint256 tokenbalance = Token(_token).balanceOf(msg.sender);
		require(tokenbalance > 0, "Insufficient token balance");
		// Transfer user's token balance to the new contract.
		Token(_token).transferFrom(msg.sender, address(this), tokenbalance);

		// Calculate the new token balance
		uint256 newAmt;
		if (_token == token1) {
			newAmt = SafeMath.mul(SafeMath.div(tokenbalance, 1e18), rate1);
		}
		else {
			newAmt = SafeMath.mul(SafeMath.div(tokenbalance, 1e18), rate2);
		}

		// Mint new tokens
		Token(newToken).mint(msg.sender, newAmt);

		emit Merge(_token, msg.sender, tokenbalance);
	}
}