// SPDX-License-Identifier: MIT
pragma solidity ^0.8;
// 作业3：编写一个讨饭合约
// 任务目标
// 使用 Solidity 编写一个合约，允许用户向合约地址发送以太币。
// 记录每个捐赠者的地址和捐赠金额。
// 允许合约所有者提取所有捐赠的资金。
contract BeggingContract {
    // 每个捐赠者的地址和捐赠金额
    mapping(address => uint256) public donations;

    // 定义 Donation 事件，记录捐赠者地址和金额
    event Donation(address indexed donor, uint256 amount);
    // 事件，记录取款信息
    event FundsWithdrawn(uint256 amount);

    // 合约所有者
    address public owner;

    // 构造函数，在合约创建时设置所有者
    constructor() {
        owner = msg.sender;
    }

    // 捐赠函数，使用 payable 修饰符允许接收以太币
    function donate() external payable {
        require(msg.value > 0, "Donation value must be greater than 0");
        donations[msg.sender] += msg.value;
        emit Donation(msg.sender, msg.value);
    }

    // 提款函数，只有合约所有者可以调用
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the contract owner can call this function");
        _;
    }

    // 提款功能
    function withdraw() external onlyOwner {
        uint256 balance = address(this).balance;
        require(balance > 0, "No funds to withdraw");
        payable(owner).transfer(balance);
        emit FundsWithdrawn(balance);
    }

    // 查询某个地址的捐赠金额
    function getDonation(address _address) public view returns (uint256) {
        return donations[_address];
    }
}