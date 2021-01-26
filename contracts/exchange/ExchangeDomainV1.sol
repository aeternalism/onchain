// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.6.0 <0.8.0;

library ExchangeDomainV1 {
  enum AssetType {
    ETH,
    ERC20,
    ERC721,
    ERC1155
  }

  enum OrderType {
    BIDDING,
    AUCTION
  }

  struct Asset {
    AssetType assetType;
    address token;
    uint256 tokenId;
  }

  struct Order {
    address owner;
    address buyer;
    /* sell */
    Asset sellAsset;
    /* sell amount */
    uint256 sellAmount;
    /* order type */
    OrderType orderType;
    /* get back */
    Asset returnAsset;
    /* return amount or bidding amount */
    uint256 returnAmount;
    /* hash */
    string hashMessage;
    /* fee */
    uint256 fee;
  }
}