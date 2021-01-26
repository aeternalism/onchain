// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.6.0 <0.8.0;
pragma abicoder v2;

import './ExchangeDomainV1.sol';

contract ExchangeStateV1 {
    
  enum OrderState {
    PENDING,
    COMPLETED,
    FAILED
  }
  
  mapping(bytes32 => OrderState) public ordersState;
  
  function getState(ExchangeDomainV1.Order calldata _order)
    external
    view
    returns(OrderState)
  {
    return ordersState[hashOrder(_order)];
  }
  
  function setCompleted(ExchangeDomainV1.Order calldata _order)
    external
  {
    ordersState[hashOrder(_order)] = OrderState.COMPLETED;
  }
  
  function hashOrder(ExchangeDomainV1.Order calldata _order) 
    public
    pure
    returns(bytes32)
  {
    return keccak256(abi.encodePacked(_order.owner, _order.sellAsset.token, _order.sellAsset.tokenId, _order.orderType, _order.returnAsset.token, _order.returnAsset.tokenId));
  }
    
}