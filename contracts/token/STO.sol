// SPDX-License-Identifier: MIT
pragma solidity ^0.8.1;

import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

import "hardhat/console.sol";

/**
 * @title STO Token
 * @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator.
 * Note they can later distribute these tokens as they wish using `transfer` and other
 * `ERC20` functions.
 */
contract STO is ERC20, ReentrancyGuard, Ownable, AccessControl {
    using SafeMath for uint256;
    using SafeERC20 for IERC20;

    // Variable
    uint256 public fundraisingGoal;
    uint256 public raised;
    uint256 public tokenPrice;
    address public admin;
    address[] public whitelistedAddresses;

    // Mapping
    mapping(address => uint256) raiser;

    // Events
    event FundTransfer(address indexed investor, uint256 value);
    event FundRaised();

    constructor(
        string memory name,
        string memory symbol,
        uint256 _fundraisingGoal,
        uint256 _tokenPrice,
        address _admin
    ) public ERC20(name, symbol) {
        fundraisingGoal = _fundraisingGoal;
        tokenPrice = _tokenPrice;
        admin = _admin;
    }

    // Invest user get token
    function invest() public payable {
        require(isWhitelisted(msg.sender), "User is not in whitelist");
        require(msg.value > 0, "Amount need over 0");
        require(msg.value >= tokenPrice, "Amount need correct price");
        require(raised.add(msg.value) <= fundraisingGoal, "Limited to goal");
        uint256 tokenAmount = msg.value.div(tokenPrice);
        // uint256 remainingWei = msg.value.sub(tokenAmount.mul(tokenPrice));
        // console.log(remainingWei);
        // console.log(tokenAmount);
        // tokenAmount = tokenAmount.add(remainingWei.mul(10**18).div(tokenPrice));
        payable(admin).transfer(msg.value);
        raised = raised.add(msg.value);
        raiser[msg.sender].add(msg.value);
        _mint(msg.sender, tokenAmount * 10**18);
        emit FundTransfer(msg.sender, msg.value);
        if (raised == fundraisingGoal) {
            emit FundRaised();
        }
    }

    function addToWhitelist(address _address) public onlyOwner {
        require(
            _address != address(0),
            "Cannot add address 0x0 to the whitelist."
        );
        whitelistedAddresses.push(_address);
    }

    function removeFromWhitelist(address _address) public onlyOwner {
        uint256 index = 0;
        for (uint256 i = 0; i < whitelistedAddresses.length; i++) {
            if (whitelistedAddresses[i] == _address) {
                index = i;
                break;
            }
        }
        whitelistedAddresses[index] = whitelistedAddresses[
            whitelistedAddresses.length - 1
        ];
    }

    function isWhitelisted(address _address) public view returns (bool) {
        for (uint256 i = 0; i < whitelistedAddresses.length; i++) {
            if (whitelistedAddresses[i] == _address) {
                return true;
            }
        }
        return false;
    }
}
