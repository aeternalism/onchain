// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.6.0 <0.8.0;
pragma abicoder v2;

import './AeBase.sol';
import './token/erc1155/AbstractCollectible.sol';
import './token/erc1155/AeCollectible.sol';

import 'hardhat/console.sol';

contract AeMarket is AeBase {

  address private operator;
  mapping(address => bool) private _collectibles;

  event CollectibleMinted(address _sender, address _contract, uint256 _id, uint256 _amount);

  constructor() {}

  function setOperatorAddress(address _operator)
    external
    onlySuperAdmin
  {
    operator = _operator;
  }

  function setCollectible(address _collectibleAddress, bool enabled)
    external
    onlySuperAdmin
  {
    _collectibles[_collectibleAddress] = enabled;
  }

  function createCollectible(string memory _uri)
    public
  {
    AeCollectible _collectible = new AeCollectible(_uri);
    _collectibles[address(_collectible)] = true;
  }

  /// function list
  /// 1. mint collectible
  function mintCollectible(address _collectibleAddress, uint256 _id, uint256 _amount)
    external
  {
    require(_collectibles[_collectibleAddress], "Not supported collectible");

    AbstractCollectible collectible = AbstractCollectible(_collectibleAddress);
    collectible.mint(msg.sender, _id, _amount, "");

    emit CollectibleMinted(msg.sender, _collectibleAddress, _id, _amount);
  }

}
