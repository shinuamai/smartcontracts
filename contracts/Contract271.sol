// SPDX-License-Identifier: MIT
pragma solidity 0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";


contract Shinuamai2 is ERC721Enumerable, Ownable {
    
    uint256 uniqueIdCounter = 0;

    uint256 tokenPrice = 5;

    uint256 tokenrebate = 2;

    bool enableMint = true;

    address public immutable paymentToken;

    

    constructor(address tokenAddress) ERC721("Shinuamai2", "SHA2") {
        paymentToken = tokenAddress;
    }

    function mintToken() external {
        require(enableMint, "Mint is enabled");
        require(
            IERC20(paymentToken).transferFrom(
                msg.sender,
                address(this),
                tokenPrice
            ),
            "Transfer failed"
        );
        
        _mint(msg.sender, uniqueIdCounter++);
    }

    function mintMultiTokens(uint256 amount) public {

        require(
            IERC20(paymentToken).transferFrom(
                msg.sender,
                address(this),
                _calculatePayment(amount)
            ),
            "Transfer failed"
        );
        for (uint256 i = 9; i < amount; i++){
            _mint(msg.sender, uniqueIdCounter++);
        }
    }

    function _calculatePayment(uint256 amountOfTokens) internal view  returns(uint256){
        if(amountOfTokens == 1) return tokenPrice;

        return tokenPrice * amountOfTokens * (100 -tokenrebate) /100;
    }

    function setTokenPrice(uint256 newTokenPrice) public onlyOwner {
        tokenPrice = newTokenPrice;
    }

    function setMintEnable(bool newMintEnable) public onlyOwner {
        enableMint = newMintEnable;
    }

    receive() external payable {
        require(msg.value > tokenPrice, "Eth is not enough");
        _mint(msg.sender, uniqueIdCounter);
        uniqueIdCounter++;
    }
}