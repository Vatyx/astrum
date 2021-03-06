pragma solidity ^0.4.19;

import "./Ownable.sol";

contract Asset is Ownable {

    mapping (string => address) ownership;
    mapping (string => uint) sale;

    event SaleSet(string key, uint amount);
    event Bought(string key, address from, address to);
    event Transfer(string key, address from, address to);
    event Burned(string key, address from);
    event Created(string key, address to);

    function owner_of(string _key) public view returns (address _owner) {
        _owner = ownership[_key];
        // if (_owner == address(0)) {
        //     _owner = owner;
        // }
    }

    modifier only_owner_of(string _key) {
        require(owner_of(_key) == msg.sender);
        _;
    }

    function set_sale(string _key, uint _price) public only_owner_of(_key) {
        sale[_key] = _price;
        SaleSet(_key, _price);
    }

    function get_sale(string _key) public view returns (uint) {
        return sale[_key];
    }

    function buy(string _key) public {
        uint _cost = get_sale(_key);
        require(_cost > 0);
        address _owner = owner_of(_key);
        Bought(_key, _owner, msg.sender);
        transfer(_key, _owner, msg.sender);
        set_sale(_key, 0);
    }

    function transfer(string _key, address _to) public only_owner_of(_key) {
        transfer(_key, msg.sender, _to);
    }

    function transfer(string _key, address _from, address _to) private {
        address _owner = owner_of(_key);
        require(_owner == _from);
        ownership[_key] = _to;
        Transfer(_key, _from, _to);
    }

    function burn(string _key) internal {
        delete ownership[_key];
        Burned(_key, msg.sender);
    }


    function create(string _key) public only_owner() {
        create(_key, msg.sender);
    }

    function create(string _key, address _to) internal {
        ownership[_key] = _to;
        Created(_key, _to);
    }

}