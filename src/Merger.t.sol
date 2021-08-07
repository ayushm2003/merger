pragma solidity ^0.8.6;

import "ds-test/test.sol";

import "./Merger.sol";

contract MergerTest is DSTest {
    Merger merger;

    function setUp() public {
        merger = new Merger();
    }

    function testFail_basic_sanity() public {
        assertTrue(false);
    }

    function test_basic_sanity() public {
        assertTrue(true);
    }
}
