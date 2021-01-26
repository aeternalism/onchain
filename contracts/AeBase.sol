// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.6.0 <0.8.0;

import '@openzeppelin/contracts/utils/Pausable.sol';
import './access/AeAccessControl.sol';

contract AeBase is AeAccessControl, Pausable {

  function pause() 
    public
    whenNotPaused
    onlySuperAdmin
  {
    _pause();
  }

  function unpause()
    public
    whenPaused
    onlySuperAdmin
  {
    _unpause();
  }

}