pragma solidity ^0.4.21;
contract SecFS {
    address private owner;
    
    modifier onlyOwner {
        require(owner == msg.sender);
        _;
    }

    struct AccessItem {
        string url;
        address owner;
        string ownerKey;
        string acl;
    }
    
    mapping(bytes32 => AccessItem) private itemList;
    mapping(bytes32 => string) private data;
    mapping(address => string) public userPK;
    
    function SecFS() public {
        owner = msg.sender;
    }
    
    function setData(string _id, string _url, string _ownerKey, string _data) public {
        bytes32 id = keccak256(_id);
        AccessItem storage item = itemList[id];
        
        require(item.owner == address(0) || item.owner == msg.sender);
        
        item.url = _url;
        item.owner = msg.sender;
        item.ownerKey = _ownerKey;
        itemList[id] = item;
        if (bytes(_data).length != 0 || bytes(data[id]).length != 0) {
            data[id] = _data;
        }
    }
    function getData(string _id) constant external returns(string) {
        return data[keccak256(_id)];
    }
    
    function getOwnerKey(string _id) constant external returns(string) {
        return itemList[keccak256(_id)].ownerKey;
    }
    
    function getACL(string _id) constant external returns(string) {
        return itemList[keccak256(_id)].acl;
    }
    
    function setACL(string _id, string _acl) external {
        itemList[keccak256(_id)].acl = _acl;
    }

    function setUserPK(address _account, string _pk) onlyOwner external {
        userPK[_account] = _pk;
    }
}