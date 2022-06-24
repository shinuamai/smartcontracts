// SPDX-License-Identifier: MIT
pragma solidity 0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import {Shinuamai} from "./Shinuamai.sol";

contract Staking is Ownable {
    // reward rate is in units token/(second + token)
    uint256 public rewardRate = 3;
    address public tokenContract;
    
    struct StakingData {
        uint256 amount;
        uint256 timestamp;
    }

    mapping(address => StakingData) public _stakingDataByAddress;

    constructor(address _tokenContract) {
        tokenContract = _tokenContract;
    }


    function deposiToken(uint256 amount) public {
        StakingData memory data = _stakingDataByAddress[msg.sender];

        if (data.amount > 0) getRewards();

        require(
            IERC20(tokenContract).transferFrom(
                msg.sender,
                address(this),
                amount
            ),
            "Transfer failed"
        );

        data.amount += amount;
        data.timestamp = block.timestamp;

        _stakingDataByAddress[msg.sender] = data;
    }

    function getRewards() public {
        StakingData memory data = _stakingDataByAddress[msg.sender];

        uint256 reward = data.amount *
            (block.timestamp - data.timestamp) *
            rewardRate;

        Shinuamai(tokenContract).mintForStaking(msg.sender, reward);

        data.timestamp = block.timestamp;

        _stakingDataByAddress[msg.sender] = data;
    }

    function retrieve() public {
        //getRewards();

        require(
            IERC20(tokenContract).transfer(
                msg.sender,
                _stakingDataByAddress[msg.sender].amount
            ),
            "Transfer failed"
        );
        delete _stakingDataByAddress[msg.sender];
    }

    function exit() public {
        retrieve();
        getRewards();
    }

    function setokenContract(address contractAddress) external onlyOwner {
        tokenContract = contractAddress;
    }
}
