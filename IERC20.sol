 //SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

/**
 * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
 * the optional functions; to access them see `ERC20Detailed`.
 */

interface IERC20 {
    function name() external view returns (string memory);

    function symbol() external view returns (string memory);

    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function transfer(address recipient, uint256 amount) external returns (bool);

    function allowance(address owner, address spender) external view returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);

    event Approval(address indexed owner, address indexed spender, uint256 value);
}

contract Ownership {
    address public owner;
    address public newOwner;

    event ownershipTransferred(address indexed _from, address indexed _to);

    modifier onlyOwner(){
        require(msg.sender == owner);
        _;
    }
    modifier onlyNewOwner(){
        require(msg.sender == newOwner);
        _;
    }
    constructor(){
        owner = msg.sender;
    }
    function transferOwnership(address _to) public onlyOwner {
        newOwner = _to;
    }
    function acceptOwnership() public onlyNewOwner {
        emit ownershipTransferred(owner, newOwner);
        owner = newOwner;
        newOwner = address(0);
    }
}