// SPDX-License-Identifier: MIT
pragma solidity 0.5.16;

import "lib/ds-test/src/test.sol";

import "./Merger.sol";
import "./Gov/GovERC20.sol";
import "./Gov/GovernorAlpha.sol";
import "./Gov/Timelock.sol";

contract MergerTest is DSTest {
    Merger merger;
    Token token1;
    Token token2;

    function setUp() public {
        token1 = new Token(address(this), "Token1", "TOK1");
        token2 = new Token(address(this), "Token2", "TOK2");

        merger = new Merger(address(token1), address(token2), 10, 1, "UnAAve", "COLLAB", 10 days, "UnAAVe Governance");
    }

    function testFail_basic_sanity() public {
        assertTrue(false);
    }

    function test_basic_sanity() public {
        assertTrue(true);
    }

    function test_erc20_token_creation() public {
        address newToken = merger.newToken();
        assertTrue(keccak256(abi.encodePacked(Token(newToken).name())) == keccak256(abi.encodePacked("UnAAve")));
    }

    function test_timelock_creation() public {
        address payable timelock = address(uint160(address(merger.timelock())));
        assertTrue(Timelock(timelock).admin() == address(merger));
    }

    function test_govAlpha_creation() public {
        address govAlpha = merger.govAlpha();
        assertTrue(keccak256(abi.encodePacked(GovernorAlpha(govAlpha).name())) == keccak256(abi.encodePacked("UnAAVe Governance")));
    }
}
