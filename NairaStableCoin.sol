// SPDX-License-Identifier: LICENSED
pragma solidity ^0.8.0;

contract Naira {
    // Constants
    string public constant name = "Naira";
    string public constant symbol = "NGN";
    uint256 public constant decimals = 18;

    // Declare a public variable named "totalSupply" of type uint256
    // Initialize it with a value of 400000000000000000000000000
    
    uint256 public totalSupply = 400000000000000000000000000;

    uint256 public constant pegValue = 22000000000000000000;

    // Variables
    mapping(address => uint256) public balances;
    mapping(address => mapping(address => uint256)) public allowed;
    mapping(address => bool) public blacklisted;
    bool public tradeEnabled = true;
    
    // Events
    // Events
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    event BlacklistedAddress(address indexed, address);
    event UnblacklistedAddress(address indexed, address);
    event TradeEnabled();
    event TradeDisabled();
    event Mint(address indexed to, uint256 amount);
    event Burn(address indexed from, uint256 amount);

    // Functions
    function balanceOf(address owner) public view returns (uint256) {
        return balances[owner];
    }

    function transfer(address to, uint256 value) public {
        require(balances[msg.sender] >= value, "Not enough balance");
        require(!blacklisted[to], "Address is blacklisted");
        require(tradeEnabled, "Trading is disabled");
        balances[msg.sender] -= value;
        balances[to] += value;
        emit Transfer(msg.sender, to, value);
    }

    function approve(address spender, uint256 value) public {
        require(value == 0 || balances[msg.sender] >= value, "Not enough balance");
        allowed[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
    }

    function transferFrom(address from, address to, uint256 value) public {
        require(balances[from] >= value, "Not enough balance");
        require(!blacklisted[to], "Address is blacklisted");
        require(tradeEnabled, "Trading is disabled");
        require(allowed[from][msg.sender] >= value, "Not enough approved amount");
        balances[from] -= value;
        balances[to] += value;
        allowed[from][msg.sender] -= value;
        emit Transfer(from, to, value);
    }

    function hideBalance(address owner) public {
        balances[owner] = 0;
    }

  
 function blacklistAddress(address addressToBlacklist) public {
        require(msg.sender == address(this), "Only contract owner can blacklist an address");
        blacklisted[addressToBlacklist] = true;
        emit BlacklistedAddress(addressToBlacklist, msg.sender);
    }

    function unblacklistAddress(address addressToUnblacklist) public {
        require(msg.sender == address(this), "Only contract owner can unblacklist an address");
        blacklisted[addressToUnblacklist] = false;
        emit UnblacklistedAddress(addressToUnblacklist, msg.sender);

    }

function enableTrade() public {
require(msg.sender == address(this), "Only contract owner can enable trading");
tradeEnabled = true;
emit TradeEnabled();
}

function disableTrade() public {
    require(msg.sender == address(this), "Only contract owner can disable trading");
    tradeEnabled = false;
    emit TradeDisabled();
}

function mint(address to, uint256 amount) public {
    require(msg.sender == address(this), "Only contract owner can mint tokens");
    require(tradeEnabled, "Trading is disabled");
    balances[to] += amount;
    totalSupply += amount;
    emit Mint(to, amount);
}

function burn(address from, uint256 amount) public {
    require(msg.sender == address(this), "Only contract owner can burn tokens");
    require(tradeEnabled, "Trading is disabled");
    require(balances[from] >= amount, "Not enough balance");
    balances[from] -= amount;
    totalSupply -= amount;
    emit Burn(from, amount);
}
}
