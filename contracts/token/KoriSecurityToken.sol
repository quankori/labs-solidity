// SPDX-License-Identifier: MIT
pragma solidity ^0.8.1;

import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

/**
 * @title STO Token
 * @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator.
 * Note they can later distribute these tokens as they wish using `transfer` and other
 * `ERC20` functions.
 */
contract KoriSTO is ERC20, ReentrancyGuard, Ownable, AccessControl {
    using SafeMath for uint256;
    using SafeERC20 for IERC20;

    // Variable
    uint256 public fundraisingGoal;
    uint256 public raised;
    uint256 public tokenPrice;
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
        uint256 initialSupply
    ) public ERC20(name, symbol) {
        _mint(msg.sender, initialSupply);
        fundraisingGoal = _fundraisingGoal;
        tokenPrice = _tokenPrice;
    }

    // Invest user get token
    function invest() public payable {
        require(isWhitelisted(msg.sender));
        require(msg.value > 0);
        require(msg.value >= tokenPrice);
        require(raised.add(msg.value) <= fundraisingGoal);
        uint256 tokens = msg.value.div(tokenPrice);
        transfer(msg.sender, tokens);
        raised = raised.add(msg.value);
        raiser[msg.sender].add(msg.value);
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
