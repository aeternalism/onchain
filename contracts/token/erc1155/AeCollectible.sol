// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.6.0 <0.8.0;

import '../../access/AeAccessControl.sol';
import './AbstractCollectible.sol';

contract AeCollectible is AeAccessControl, AbstractCollectible {

    mapping(uint256 => bool) internal _existedIds;

    constructor(string memory _uri)
        public
        ERC1155(_uri)
    {}

    function mint(address to, uint256 id, uint256 amount, bytes memory data) 
        external
        override
    {
        require(!_existedIds[id], "Existed ID");
        _existedIds[id] = true;
        _mint(to, id, amount, data);
    }

    function mintBatch(address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data) 
        external 
        override
    {
        for (uint256 i = 0; i < ids.length; i++) {
            require(!_existedIds[ids[i]], "Existed ID");
            _existedIds[ids[i]] = true;
        }
        _mintBatch(to, ids, amounts, data);
    }

}