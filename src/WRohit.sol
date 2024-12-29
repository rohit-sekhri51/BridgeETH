// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import { console } from "forge-std/console.sol";
import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";


contract WRohit is ERC20, Ownable {

    constructor() ERC20("WRohit", "WRHT") Ownable(msg.sender) {
    }

    // 1.c Mint WRohit() in the WRohit contract equal to the amount of Rohit() deposited/locked in the BridgeETH contract
    function mint(address _to, uint256 _amount) public onlyOwner {
        _mint(_to, _amount);
    }

    // 2.a Burn WRohit() in the WRohit contract equal to the amount of WRohit() withdrawn/unlocked in the BridgeBase contract
    function burn(address _to, uint256 _amount) public onlyOwner {
        _burn(_to, _amount);
    }
}