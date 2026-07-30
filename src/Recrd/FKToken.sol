// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

import { Initializable } from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import { ERC20Upgradeable } from "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import { ERC20PermitUpgradeable } from "@openzeppelin/contracts-upgradeable/token/ERC20/extensions/ERC20PermitUpgradeable.sol";
import { OwnableUpgradeable } from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import { UUPSUpgradeable } from "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

/**
 * @title FKToken (FKToken)
 * @notice Upgradeable ERC-20 collateral token for the Recrd prediction market ecosystem.
 * @dev Implements:
 *      - Upgradeable ERC-20 standard
 *      - EIP-2612 Permit (gasless approvals)
 *      - Native `increaseAllowance` and `decreaseAllowance`
 *      - UUPS Upgradeability Pattern
 *      - Initial supply of 1,000,000 FKT minted to the initial owner on initialization.
 */
contract FKToken is Initializable, ERC20Upgradeable, ERC20PermitUpgradeable, OwnableUpgradeable, UUPSUpgradeable {

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
        __Ownable_init();
        __UUPSUpgradeable_init();

        address targetOwner = initialOwner != address(0) ? initialOwner : msg.sender;
        _transferOwnership(targetOwner);

        // Mint initial supply of 1,000,000 FKT (18 decimals)
        _mint(targetOwner, 1_000_000 * 10**decimals());
    }

    /**
     * @notice Mints new tokens for testing/collateral purposes.
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
     * @dev Authorizes logic upgrades (UUPS pattern). Restrictable to owner.
     */
    function _authorizeUpgrade(address newImplementation) internal override onlyOwner {}
}
