// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import { console } from "forge-std/console.sol";
import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";


contract BridgeETH is Ownable {
    uint256 public balance;
    address public tokenAddress;

    mapping(address => uint256) public pendingBalance;

    event Deposit(address indexed depositor, uint256 amount);

    constructor(address _tokenAddress) Ownable(msg.sender) {       // USDC ERC20 address = _tokenAddress
        tokenAddress = _tokenAddress;
    }
    
    // 1.b Lock Rohit() minted before this step in the BridgeETH contract
    function deposit(IERC20 _tokenAddress, uint256 _amount) public {    // USDC ERC20 address = _tokenAddress
        require(address(_tokenAddress) == tokenAddress);
        require(_tokenAddress.allowance(msg.sender, address(this)) >= _amount);     // msg.sender = User
        require(_tokenAddress.transferFrom(msg.sender, address(this), _amount));    // address(this) = Lock contract     
        pendingBalance[msg.sender] += _amount;      // User's balance stored in Lock contract
        emit Deposit(msg.sender, _amount);
    }

    // 2.b Unlock Rohit() equal to the amount of Rohit() burned in WRohit contract
    function withdraw(IERC20 _tokenAddress, uint256 _amount) public {
        require(address(_tokenAddress) == tokenAddress);
        require(pendingBalance[msg.sender] >= _amount);     // check
        pendingBalance[msg.sender] -= _amount;              // User balance debited
        _tokenAddress.transfer(msg.sender, _amount);        // In the USDC contract, User balance restored/transfer 
    }

    function burnedOnOtherSide() public onlyOwner {

    }
}