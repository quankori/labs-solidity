// SPDX-License-Identifier: MIT
pragma solidity ^0.8.1;

import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

/**
 * @title STO Token
 * @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator.
 * Note they can later distribute these tokens as they wish using `transfer` and other
 * `ERC20` functions.
 */
contract KoriSTO is ERC20 {
    using SafeMath for uint256;

    // Variable
    uint256 public fundraisingGoal;
    uint256 public raised;
    uint256 public tokenPrice;

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
}
