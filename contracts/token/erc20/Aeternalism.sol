// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.6.0 <0.8.0;

import '@openzeppelin/contracts/access/AccessControl.sol';
import '@openzeppelin/contracts/math/SafeMath.sol';
import '@openzeppelin/contracts/token/ERC20/ERC20.sol';
import './IERC20Mintable.sol';

/// @title Aeternalism smart contract
/// @author Le Brian
/// @notice This contract is used for trading, token sale event and future DAO
contract Aeternalism is ERC20, IERC20Mintable, AccessControl {

    using SafeMath for uint256;

    uint256 private _cap = 10**24;
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");

    constructor()
        ERC20("Aeternalism", "AES")
    {
        /// deployer will be the default admin
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
        /// grant MINTER role to deployer & issuance contract to mint token to investors
        grantRole(MINTER_ROLE, msg.sender);
        grantRole(MINTER_ROLE, 0xC0F5c3aB6e76B30deec963c86175F0f4e75a16A9);
    }

    /// @notice Hook before token transfer
    /// @param from Address transfer token - Address(0) means minting
    /// @param to Address to receive token
    /// @param amount Amount to transfer (decimals 18)
    function _beforeTokenTransfer(address from, address to, uint256 amount) 
        internal 
        virtual 
        override
    {
        super._beforeTokenTransfer(from, to, amount);

        /// check minting doesn't exceed _cap
        if (from == address(0)) {
            require(totalSupply().add(amount) <= _cap, "Max cap reached");
        }
    }
    
    /// @notice Mint token to specific address
    /// @dev Requires sender has MINTER role
    /// @param to address to receive token
    /// @param amount amount to mint (decimals 18)
    function mint(address to, uint256 amount)
        external
        override
        returns(bool)
    {
        require(hasRole(MINTER_ROLE, msg.sender), "Not a minter");
        super._mint(to, amount);
    }
}