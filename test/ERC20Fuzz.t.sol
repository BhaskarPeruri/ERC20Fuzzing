// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

import "../src/ERC20.sol";
import "forge-std/Test.sol";
import "./Mocks/MockERC20.sol";

contract ERC20FuzzTest is Test {

    MockERC20 internal token;

    address alice = vm.addr(0x9);
    address bob = vm.addr(0x10);

    
    function setUp() public virtual{
        token = new MockERC20("FUZZING", "FUZZ", 18);
    }

    function testFuzz_metadata(string memory name_, string memory symbol_, uint8 decimals_)public{
        MockERC20 mockToken = new MockERC20(name_, symbol_, decimals_);

        assertEq(mockToken.name(), name_);
        assertEq(mockToken.symbol(), symbol_);
        assertEq(mockToken.decimals(), decimals_);
    
    }
/*
You can also try this, it works.
  function testFuzz_mint() public {
        token.mint(alice, 100);

        assertEq(token.totalSupply(), 100, "total supply and 100 are equal");
        assertEq(token.balanceOf(alice), 100);
    }
*/

//testing MINT functionality
  function testFuzz_mint(address account_, uint256 amount_) public {
        token.mint(account_, amount_);

        assertEq(token.totalSupply(), amount_);
        assertEq(token.balanceOf(account_), amount_);
    }

//testing BURN functionality
    function testFuzz_burn(
        address account_,
        uint256 amount_before_burn,
        uint256 amount_after_burn
    ) public {
        if (amount_after_burn > amount_before_burn) return;

        token.mint(account_, amount_before_burn);
        token.burn(account_, amount_after_burn);

        assertEq(token.totalSupply(), amount_before_burn - amount_after_burn, "Both amounts are equal");
        assertEq(token.balanceOf(account_), amount_before_burn - amount_after_burn, "Both balance and calculated amount are equal");
    }
//testing APPROVE functionality
    function testFuzz_approve(address account_, uint256 amount_) public {
        assertTrue(token.approve(account_, amount_));

        assertEq(token.allowance(address(this), account_), amount_);
    }

//testing IncreaseAllowance functionality
function testIncreaseAllowance() external{
    assertEq(token.allowance(address(this),alice),0);
    assertTrue(token.increaseAllowance(alice, 500000));
    assertEq(token.allowance(address(this),alice),500000);
}   
}


