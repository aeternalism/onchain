// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.6.0 <0.8.0;

import '@openzeppelin/contracts/access/Ownable.sol';
import '@openzeppelin/contracts/access/AccessControl.sol';
import '@openzeppelin/contracts/token/ERC1155/ERC1155.sol';

contract AeAccessControl is Ownable, AccessControl {

  bytes32 public constant SADMIN_ROLE = keccak256("SADMIN_ROLE");
  bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");
  bytes32 public constant OPERATOR_ROLE = keccak256("OPERATOR_ROLE");

  constructor() {
    _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
    
    _setupRole(SADMIN_ROLE, msg.sender);
    _setupRole(ADMIN_ROLE, msg.sender);
    _setupRole(OPERATOR_ROLE, msg.sender);
  }

  modifier onlySuperAdmin() {
    require(hasRole(SADMIN_ROLE, msg.sender), "Only super admin");
    _;
  }

  modifier onlyAdmin() {
    require(hasRole(ADMIN_ROLE, msg.sender), "Only admin");
    _;
  }

  modifier onlyOperator() {
    require(hasRole(OPERATOR_ROLE, msg.sender), "Only operator");
    _;
  }

}
   