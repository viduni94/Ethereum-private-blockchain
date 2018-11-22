pragma solidity ^0.4.11;

contract one {
    struct ContractMetadata {
        address counterparty;
        address holder;
        bool signed;
    }

    enum Commodity {USD, GBP}

    address public counterparty;

    mapping(address => ContractMetadata) public contracts_;

    mapping(address => mapping(uint => int)) public balances_;

    constructor() public {
        balances_[msg.sender][uint(Commodity.USD)] = 0;
        balances_[msg.sender][uint(Commodity.GBP)] = 0;
        counterparty = msg.sender;
    }

    function sendCurrency(Commodity commodity, int quantity) public {
        require(msg.sender == counterparty);
        ContractMetadata storage c = contracts_[msg.sender];
        balances_[c.counterparty][uint(commodity)] -= quantity;
        balances_[c.holder][uint(commodity)] += quantity;

    }

    function kill() public onlyOwner {
        selfdestruct(counterparty);
    }

    modifier onlyOwner {
        require(msg.sender == counterparty);
        _;
    }
}

