// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract WyseAirdrop is Ownable {
    using SafeERC20 for IERC20;

    IERC20 public token;
    uint256 public reward;
    mapping(address => bool) public isClaimed;

    constructor() Ownable(msg.sender) {}

    function setParams(
        address _token,
        uint256 _deposit,
        uint256 _reward
    ) external onlyOwner {
        token = IERC20(_token);
        token.safeTransferFrom(msg.sender, address(this), _deposit);
        reward = _reward;
    }

    function setReward(uint256 _reward) external onlyOwner {
        reward = _reward;
    }

    function deposit(uint256 amount) public onlyOwner {
        token.safeTransferFrom(msg.sender, address(this), amount);
    }

    function withdraw(address _token, uint256 _amount) external onlyOwner {
        if (_token != address(0)) {
            IERC20(_token).safeTransfer(msg.sender, _amount);
        } else {
            payable(msg.sender).transfer(_amount);
        }
    }

    function claim() external {
        require(!isClaimed[msg.sender], "Giveaway: already claimed");
        isClaimed[msg.sender] = true;
        token.safeTransfer(msg.sender, reward);
    }
}