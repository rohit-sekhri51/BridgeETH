// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

import "forge-std/Test.sol";

import "src/Lock.sol";
import "src/MyToken.sol";
import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract BridgeETHTest is Test {
    event Transfer(address indexed from, address indexed to, uint256 value);

    BridgeETH bridge;
    MyToken usdt;

    function setUp() public {
        usdt = new MyToken();       // USDC address is stored in object called usdt.
        bridge = new BridgeETH(address(usdt));
    }

    function test_Deposit() public {
        usdt.mint(0x2966473D85A76A190697B5b9b66b769436EFE8e5, 200);
        vm.startPrank(0x2966473D85A76A190697B5b9b66b769436EFE8e5);
        usdt.approve(address(bridge), 200);

        bridge.deposit(usdt, 200);
        assertEq(usdt.balanceOf(0x2966473D85A76A190697B5b9b66b769436EFE8e5), 0);
        assertEq(usdt.balanceOf(address(bridge)), 200);
        //assertEq(usdt.allowance(msg.sender, address(bridge)),200);

        bridge.withdraw(usdt, 100);

        assertEq(usdt.balanceOf(0x2966473D85A76A190697B5b9b66b769436EFE8e5), 100);
        assertEq(usdt.balanceOf(address(bridge)), 100);
        //assertEq(usdt.allowance(msg.sender, address(bridge)),200);
        vm.stopPrank();

    }

    function test_DepositAssert() public {
        usdt.mint(0x2966473D85A76A190697B5b9b66b769436EFE8e5, 200);
        vm.startPrank(0x2966473D85A76A190697B5b9b66b769436EFE8e5);
        usdt.approve(address(bridge), 200);

        bridge.deposit(usdt, 200);
        assertEq(usdt.balanceOf(0x2966473D85A76A190697B5b9b66b769436EFE8e5), 0);
        assertEq(usdt.balanceOf(address(bridge)), 200);
        assertEq(usdt.allowance(msg.sender, address(bridge)),0);

        bridge.withdraw(usdt, 150);

        assertEq(usdt.balanceOf(0x2966473D85A76A190697B5b9b66b769436EFE8e5), 150);
        assertEq(usdt.balanceOf(address(bridge)), 50);
        assertEq(usdt.allowance(msg.sender, address(bridge)),0);
        vm.stopPrank();

    }

    
}

