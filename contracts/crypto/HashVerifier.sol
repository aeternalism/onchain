// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.6.0 <0.8.0;

import { ECDSA } from '@openzeppelin/contracts/cryptography/ECDSA.sol';
import '../access/AeAccessControl.sol';

contract HashVerifier is AeAccessControl {

  using ECDSA for bytes32; 

  address private encryptionAddress;
  mapping(uint256 => bool) usedNounces;

  function setEncryptionAddress(address _encryptionAddress)
    external
    onlySuperAdmin
  {
    encryptionAddress = _encryptionAddress;
  }

  function verifyClientHash(bytes32 _hash, uint256 _nounce, address _signer, bytes memory sig)
    public
    returns(bool)
  {
    require(!usedNounces[_nounce], "Already proceeded");
    address signer = _hash.recover(sig);
    if (_signer == signer) {
      usedNounces[_nounce] = true;
    }
    return _signer == signer;
  }

  function verify(bytes32 _hash, uint256 _nounce, bytes memory sig)
    public
    returns(bool)
  {
    return verifyClientHash(_hash, _nounce, encryptionAddress, sig);
  }

}
