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

        token1.mint(address(this), 100e18);

        merger = new Merger(address(token1), address(token2), 1e17, 1, "UnAAve", "COLLAB", 10 days, "UnAAVe Governance");

        token1.approve(address(merger), 100e18);
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

    function testFail_wrong_token_address() public {
        merger.swapTokens(address(0x0));
    }

    /*
    function testFail_zero_balance() public {
        merger.swapTokens(address(token1));
    }
    */

    function test_token1_balance() public {
        assertTrue(token1.balanceOf(address(this)) == 100e18);
    }

    function test_swap_token1_balance() public {
        merger.swapTokens(address(token1));
        assertTrue(token1.balanceOf(address(this)) == 0);
    }

    function test_swap_new_token_balance() public {
        address newToken = merger.newToken();
        merger.swapTokens(address(token1));
        assertTrue(Token(newToken).balanceOf(address(this)) == 10e18);
    }
}
