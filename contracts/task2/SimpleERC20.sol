// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

/**
 * @dev 定义 ERC20 接口（不包含 metadata 函数）
 */
interface IERC20 {
    /**
     * @dev Transfer 事件：记录代币转账操作
     * @param from 转出账户地址
     * @param to 转入账户地址
     * @param value 转账金额
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Approval 事件：记录授权操作
     * @param owner 授权人地址
     * @param spender 被授权人地址
     * @param value 授权金额
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);

    /**
     * @dev 获取总发行量
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev 查询某个地址的余额
     * @param account 地址
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev 从调用者地址向另一个地址转账
     * @param to 接收地址
     * @param amount 转账金额
     */
    function transfer(address to, uint256 amount) external returns (bool);

    /**
     * @dev 查询某地址允许另一地址支出的金额
     * @param owner 拥有资产的地址
     * @param spender 被授权支出的地址
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev 授权某地址支出一定金额
     * @param spender 被授权地址
     * @param amount 授权金额
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev 使用授权额度进行转账（即“代扣”）
     * @param from 付款地址
     * @param to 收款地址
     * @param amount 转账金额
     */
    function transferFrom(address from, address to, uint256 amount) external returns (bool);
}

/**
 * @dev 实现一个简单的 ERC20 代币合约
 */
contract SimpleToken is IERC20 {

    // 代币名称（如 "Simple Token"）
    string public name = "Simple Token";

    // 代币符号（如 "STK"）
    string public symbol = "STK";

    // 小数位数（通常为 18，与 ETH 一致）
    uint8 public decimals = 18;

    // 总发行量（单位是最小单位，如 1e18 表示 1 个代币）
    uint256 private _totalSupply;

    // 记录每个地址的余额（单位是最小单位）
    mapping(address => uint256) private _balances;

    // 记录授权关系：owner -> spender -> 允许支出的金额
    mapping(address => mapping(address => uint256)) private _allowances;

    // 合约所有者地址
    address public owner;

    /**
     * @dev 构造函数，在部署时自动设置合约所有者
     */
    constructor() {
        owner = msg.sender;
    }

    /**
     * @dev 限制只有合约所有者才能执行某些函数
     */
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    /**
     * @dev 获取当前总发行量
     */
    function totalSupply() public view override returns (uint256) {
        return _totalSupply;
    }

    /**
     * @dev 查询指定地址的余额
     * @param account 地址
     */
    function balanceOf(address account) public view override returns (uint256) {
        return _balances[account];
    }

    /**
     * @dev 从调用者地址转账到目标地址
     * @param to 接收地址
     * @param amount 转账金额（单位是最小单位）
     */
    function transfer(address to, uint256 amount) public override returns (bool) {
        require(balanceOf(msg.sender) >= amount, "Insufficient balance");
        _balances[msg.sender] -= amount;
        _balances[to] += amount;
        emit Transfer(msg.sender, to, amount);
        return true;
    }

    /**
     * @dev 查询授权额度
     * @param tokenOwner 拥有资产的地址
     * @param spender 被授权支出的地址
     */
    function allowance(address tokenOwner, address spender) public view override returns (uint256) {
        return _allowances[tokenOwner][spender];
    }

    /**
     * @dev 设置授权额度
     * @param spender 被授权地址
     * @param amount 授权金额
     */
    function approve(address spender, uint256 amount) public override returns (bool) {
        _allowances[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    /**
     * @dev 使用授权额度进行转账（代扣）
     * @param from 付款地址
     * @param to 收款地址
     * @param amount 转账金额
     */
    function transferFrom(address from, address to, uint256 amount) public override returns (bool) {
        uint256 allowed = allowance(from, msg.sender);
        require(allowed >= amount, "Allowance too low");

        _balances[from] -= amount;
        _balances[to] += amount;
        _allowances[from][msg.sender] -= amount;

        emit Transfer(from, to, amount);
        return true;
    }

    /**
     * @dev 增发代币（仅限合约所有者调用）
     * @param to 接收地址
     * @param amount 增发数量（单位是最小单位）
     */
    function mint(address to, uint256 amount) public onlyOwner {
        _totalSupply += amount;
        _balances[to] += amount;
        emit Transfer(address(0), to, amount); // address(0) 表示新铸造的代币
    }
}