// SPDX-License-Identifier: MIT
pragma solidity 0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
//import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";

contract Shinuamai is Ownable, ERC20 {

    address public stakingContract;

    uint256 public mintAmount = 200;

    mapping(address => bool) hasUsed;
    constructor() ERC20("Shinuamai", "SHA") {
        //_mint(msg.sender, msg.value);
    }

    function setMintAmount(uint256 newMintAmount) public onlyOwner {
        mintAmount = newMintAmount;
    }
    function setStakingContract(address _stakingContract) public onlyOwner {
        stakingContract = _stakingContract; 
    }

    function mint(address recipient) public returns (bool) {
        require(!hasUsed[msg.sender], "Address already is used");

        hasUsed[msg.sender] = true;

        _mint(recipient, mintAmount);

        return true;
    }

    function mintForStaking(address recipient, uint256 amount) public returns (bool) {
        require(msg.sender == stakingContract, "only staking contract is allowed");
         _mint(recipient, amount);
         return true;
    }    
}