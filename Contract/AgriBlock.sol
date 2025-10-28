// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title AgriBlock - Agricultural Supply Chain Smart Contract
 * @dev This contract helps track agricultural products from farmers to distributors to retailers.
 */
contract AgriBlock {
    // Struct to represent an agricultural product
    struct Product {
        uint256 id;
        string name;
        string origin;
        address currentOwner;
        bool isDelivered;
    }

    mapping(uint256 => Product) public products;
    uint256 public productCount;
    address public admin;

    event ProductRegistered(uint256 indexed id, string name, string origin, address indexed owner);
    event OwnershipTransferred(uint256 indexed id, address indexed from, address indexed to);
    event ProductDelivered(uint256 indexed id, address indexed owner);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can perform this action");
        _;
    }

    modifier onlyOwner(uint256 _id) {
        require(products[_id].currentOwner == msg.sender, "You are not the owner");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    /**
     * @dev Register a new agricultural product.
     * @param _name Product name
     * @param _origin Location of origin
     */
    function registerProduct(string memory _name, string memory _origin) public onlyAdmin {
        productCount++;
        products[productCount] = Product(productCount, _name, _origin, admin, false);
        emit ProductRegistered(productCount, _name, _origin, admin);
    }

    /**
     * @dev Transfer ownership of a product to another participant.
     * @param _id Product ID
     * @param _newOwner Address of the new owner
     */
    function transferOwnership(uint256 _id, address _newOwner) public onlyOwner(_id) {
        require(!products[_id].isDelivered, "Product already delivered");
        address previousOwner = products[_id].currentOwner;
        products[_id].currentOwner = _newOwner;
        emit OwnershipTransferred(_id, previousOwner, _newOwner);
    }

    /**
     * @dev Mark the product as delivered.
     * @param _id Product ID
     */
    function markDelivered(uint256 _id) public onlyOwner(_id) {
        products[_id].isDelivered = true;
        emit ProductDelivered(_id, msg.sender);
    }
}

