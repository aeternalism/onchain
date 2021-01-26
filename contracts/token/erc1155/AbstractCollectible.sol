// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.6.0 <0.8.0;

import '@openzeppelin/contracts/token/ERC1155/ERC1155.sol';

abstract contract AbstractCollectible is ERC1155 {

  function mint(address to, uint256 id, uint256 amount, bytes memory data) external virtual;

  function mintBatch(address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data) external virtual;

}