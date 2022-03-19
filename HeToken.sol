//SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

import"https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/math/SafeMath.sol"; 

import "./IERC20.sol";


contract HeToken is IERC20, Ownership {
    using SafeMath for uint256;

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a - b;
    assert(b <= a);
    return c;
    }

    function add(uint256 a, uint256 b) internal pure returns (uint256)   {
    uint256 c = a + b;
    assert(c >= a);
    return c;
    }


    mapping(address => uint256)  balances;
    mapping(address => mapping(address => uint256)) allowed;
    uint public _decimals;
    uint public _totalSupply;
    string public _symbol;
    string public _name;
    address public _minter;

   
    constructor(){
        _decimals = 18;
        _symbol = "HET";
        _name = "Hafsah Emekoma's Token";
        _totalSupply = 1000000000 * (10 ** _decimals);
        _minter = msg.sender;
        // _minter = 0x4A9B8E23949A569e7B03a4D8aeF5109766472A1F;
        // balances[msg.sender] = totalSupply;
        balances[_minter] = _totalSupply;
        emit Transfer(address(0), _minter, _totalSupply);
    }


    modifier sufficientBalance(uint numTokens){
        require(numTokens <= balances[msg.sender], "Insufficient balance.");
        _;
    }
    
    modifier allowTransfer(uint numTokens, address owner){
        require(numTokens <= balances[owner],"insufficient balance");
        require(numTokens <= allowed[owner][msg.sender], "Amount has exceeded allowed tokens");
        _;
    }

    event Received(uint value);

    function name() public override view returns (string memory) {
        return _name;
    }

    function symbol() public override view returns (string memory) {
        return _symbol;
    }
    
    function totalSupply() public override view returns (uint256){
        return _totalSupply;
    }

    function balanceOf(address tokenOwner) public view override returns(uint){
        return balances[tokenOwner];
    }

    function transferFrom(address owner, address to, uint numTokens) public override allowTransfer(numTokens, owner) returns(bool){
        balances[owner] = balances[owner].sub(numTokens);
        allowed[owner][msg.sender] = allowed[owner][msg.sender] - numTokens;
        balances[to] = balances[to].add(numTokens);
        emit Transfer(owner, to, numTokens);
        return true;
    }

    function transfer(address to, uint numTokens) public override sufficientBalance(numTokens) returns(bool) {
        return transferFrom(msg.sender, to, numTokens);
    }

    function approve(address delegate, uint numTokens) public override returns (bool){
        allowed[msg.sender][delegate] = numTokens;
        emit Approval(msg.sender, delegate, numTokens);
        return true;
    }

    function allowance(address owner, address delegate) public override view returns (uint){
        return allowed[owner][delegate];
    }

    function mint(uint amount) public returns (bool){
        require(msg.sender == _minter);
        balances[_minter] += amount;
        _totalSupply += amount;
        return true;
    } 

    function deposit() public payable {
        emit Received(msg.value);
    }
    
    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
    
    fallback() external payable {
        emit Received(msg.value);
    }
    receive() external payable {
        emit Received(msg.value);
    }
}