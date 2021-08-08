// SPDX-License-Identifier: MIT
pragma solidity 0.5.16;

//import "@openzeppelin/contracts/token/ERC20/extensions/ERC20VotesComp.sol";
import "./Gov/GovERC20.sol";
import "./Gov/GovernorAlpha.sol";
import "./Gov/Timelock.sol";

contract Merger {
	address public token1;
	address public token2;

	uint256 public rate1;
	uint256 public rate2;

	address public newToken;
	address public timelock;
	address public govAlpha;

	constructor(
		address _token1,
		address _token2,
		uint256 _rate1,
		uint256 _rate2,
		string memory _name,
		string memory _symbol,
		uint256 _timelockDelay,
		string memory _govName) public {

		token1 = _token1;
		token2 = _token2;
		rate1 = _rate1;
		rate2 = _rate2;

		Token token = new Token(address(this), _name, _symbol);
		newToken = address(token);
		
		Timelock timelockDeploy = new Timelock(address(this), _timelockDelay);
		timelock = address(timelockDeploy);

		GovernorAlpha alpha = new GovernorAlpha(newToken, timelock, _govName);
		govAlpha = address(alpha);
	}


}