// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

import { Test } from "forge-std/Test.sol";
import { FKToken } from "../FKToken.sol";
import { ERC1967Proxy } from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";

contract FKTokenTest is Test {
    FKToken public implementation;
    FKToken public token;
    ERC1967Proxy public proxy;

    address public owner;
    address public alice = address(0x2);
    address public bob = address(0x3);

    uint256 public ownerPrivateKey = 0xA11CE;

    function setUp() public {
        owner = vm.addr(ownerPrivateKey);

        implementation = new FKToken();
        bytes memory initData = abi.encodeWithSelector(FKToken.initialize.selector, owner);
        proxy = new ERC1967Proxy(address(implementation), initData);
        token = FKToken(address(proxy));
    }

    function test_InitialState() public {
        assertEq(token.name(), "FKToken");
        assertEq(token.symbol(), "FKT");
        assertEq(token.decimals(), 18);
        assertEq(token.owner(), owner);
        assertEq(token.totalSupply(), 1_000_000 * 10**18);
        assertEq(token.balanceOf(owner), 1_000_000 * 10**18);
    }

    function test_IncreaseAndDecreaseAllowance() public {
        vm.prank(owner);
        token.increaseAllowance(alice, 500 * 10**18);
        assertEq(token.allowance(owner, alice), 500 * 10**18);

        vm.prank(owner);
        token.decreaseAllowance(alice, 200 * 10**18);
        assertEq(token.allowance(owner, alice), 300 * 10**18);
    }

    function test_MintAndBurn() public {
        vm.prank(owner);
        token.mint(alice, 1000 * 10**18);
        assertEq(token.balanceOf(alice), 1000 * 10**18);

        vm.prank(alice);
        token.burn(400 * 10**18);
        assertEq(token.balanceOf(alice), 600 * 10**18);
    }

    function test_Permit() public {
        uint256 amount = 100 * 10**18;
        uint256 deadline = block.timestamp + 1 hours;
        uint256 nonce = token.nonces(owner);

        bytes32 domainSeparator = token.DOMAIN_SEPARATOR();
        bytes32 structHash = keccak256(
            abi.encode(
                keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)"),
                owner,
                alice,
                amount,
                nonce,
                deadline
            )
        );

        bytes32 digest = keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(ownerPrivateKey, digest);

        token.permit(owner, alice, amount, deadline, v, r, s);
        assertEq(token.allowance(owner, alice), amount);
    }
}
