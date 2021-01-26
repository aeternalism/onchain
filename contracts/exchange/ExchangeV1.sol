// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.6.0 <0.8.0;
pragma abicoder v2;

import './IExchange.sol';
import './ExchangeDomainV1.sol';

import '@openzeppelin/contracts/token/ERC20/IERC20.sol';
import '@openzeppelin/contracts/token/ERC721/IERC721.sol';
import '@openzeppelin/contracts/token/ERC1155/IERC1155.sol';

import 'hardhat/console.sol';

contract ExchangeV1 is IExchange {
  
  constructor() {}

  function purchaseOne(
    ExchangeDomainV1.Order memory _order
  )
    payable
    external
  {

    console.log("sender %s", msg.sender);

    // check owner balance
    IERC1155 sellItem = IERC1155(_order.sellAsset.token);
    require(_order.sellAmount <= sellItem.balanceOf(_order.owner, _order.sellAsset.tokenId), "Not enough sell asset");

    /* 
    * return asset could be ETH, ERC20, or ERC1155
    * 1. check buyer balance
    * 2. transfer asset from buyer to seller
    * 3. transfer NFT from seller to buyer
    */ 
    if (_order.returnAsset.assetType == ExchangeDomainV1.AssetType.ERC1155) {
      // 1
      IERC1155 returnItem = IERC1155(_order.returnAsset.token);
      require(_order.returnAmount <= returnItem.balanceOf(_order.buyer, _order.returnAsset.tokenId), "Not enough return ERC1155");

      // 2
      returnItem.safeTransferFrom(_order.buyer, _order.owner, _order.returnAsset.tokenId, _order.returnAmount, "");
    } else if (_order.returnAsset.assetType == ExchangeDomainV1.AssetType.ERC20) {
      // 1
      IERC20 returnItem = IERC20(_order.returnAsset.token);
      require(_order.returnAmount <= returnItem.balanceOf(_order.buyer), "Not enough return ERC20");

      // 2
      returnItem.transferFrom(_order.buyer, _order.owner, _order.returnAmount);
    } else {
      // 1
      require(_order.returnAmount <= address(_order.buyer).balance, "Not enough ETH");

      // 2
      (bool success, ) = _order.owner.call{value: _order.returnAmount}("");
      require(success, "Transfer failed");
    }

    /* 3 */
    sellItem.safeTransferFrom(_order.owner, _order.buyer, _order.sellAsset.tokenId, _order.sellAmount, "");
  }

  function batchPurchase(
    ExchangeDomainV1.Order[] memory _orders
  )
    payable
    external
  {
    /* loop through orders and transfer money */

  }
}