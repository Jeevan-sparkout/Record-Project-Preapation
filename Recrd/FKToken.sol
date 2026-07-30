// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

import { Initializable } from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import { ERC20Upgradeable } from "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import { ERC20PermitUpgradeable } from "@openzeppelin/contracts-upgradeable/token/ERC20/extensions/ERC20PermitUpgradeable.sol";
import { PausableUpgradeable } from "@openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol";
import { OwnableUpgradeable } from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import { UUPSUpgradeable } from "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

/**
 * @title FKToken (FKToken)
 * @notice Upgradeable ERC-20 collateral token for the Recrd prediction market ecosystem.
 * @dev Implements:
 *      - Upgradeable ERC-20 standard (18 decimals)
 *      - EIP-2612 Permit (gasless approvals)
 *      - Native `increaseAllowance` and `decreaseAllowance`
 *      - Pausable Transfers (PausableUpgradeable)
 *      - UUPS Upgradeability Pattern
 *      - Initial supply of 1,000,000 FKT minted to the initial owner on initialization.
 */
contract FKToken is
    Initializable,
    ERC20Upgradeable,
    ERC20PermitUpgradeable,
    PausableUpgradeable,
    OwnableUpgradeable,
    UUPSUpgradeable
{
    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    /**
     * @notice Initializes the FKToken contract and mints 1,000,000 FKT to initialOwner.
     * @param initialOwner Address to receive ownership and initial token supply.
     */
    function initialize(address initialOwner) external initializer {
        __ERC20_init("FKToken", "FKT");
        __ERC20Permit_init("FKToken");
        __Pausable_init();
        __Ownable_init();
        __UUPSUpgradeable_init();

        address targetOwner = initialOwner != address(0) ? initialOwner : msg.sender;
        _transferOwnership(targetOwner);

        // Mint initial supply of 1,000,000 FKT (18 decimals)
        _mint(targetOwner, 1_000_000 * 10**decimals());
    }

    /**
     * @notice Pauses all token transfers (onlyOwner).
     */
    function pause() external onlyOwner {
        _pause();
    }

    /**
     * @notice Unpauses all token transfers (onlyOwner).
     */
    function unpause() external onlyOwner {
        _unpause();
    }

    /**
     * @notice Mints new tokens for collateral/testing purposes.
     * @param to Recipient address.
     * @param amount Amount to mint.
     */
    function mint(address to, uint256 amount) external onlyOwner {
        _mint(to, amount);
    }

    /**
     * @notice Burns tokens from caller's balance.
     * @param amount Amount of tokens to burn.
     */
    function burn(uint256 amount) external {
        _burn(msg.sender, amount);
    }

    /**
     * @dev Hook that is called before any transfer of tokens (enforces pause state).
     */
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal override whenNotPaused {
        super._beforeTokenTransfer(from, to, amount);
    }

    /**
     * @dev Authorizes logic upgrades (UUPS pattern). Restricted to owner.
     */
    function _authorizeUpgrade(address newImplementation) internal override onlyOwner {}
}
