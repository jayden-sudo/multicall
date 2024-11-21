// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {IERC20} from "./IERC20.sol";

contract MulticallERC20 {
    /**
     * @notice Multicall function to fetch ERC20 token data for multiple addresses
     * @param target Target wallet address
     * @param fetchDecimals Fetch decimals
     * @param fetchSymbol Fetch symbol
     * @param fetchName Fetch name
     * @param erc20Addresses Array of ERC20 addresses
     * @return balances Array of balances, balance=max(uint256) means the token is not supported
     * @return decimals Array of decimals, 0 means the token is not supported
     * @return symbols Array of symbols, empty string means the token is not supported
     * @return names Array of names, empty string means the token is not supported
     */
    function erc20(
        address target,
        bool fetchDecimals,
        bool fetchSymbol,
        bool fetchName,
        IERC20[] calldata erc20Addresses
    )
        external
        view
        returns (
            uint256[] memory balances,
            uint8[] memory decimals,
            string[] memory symbols,
            string[] memory names
        )
    {
        balances = new uint256[](erc20Addresses.length);
        for (uint256 i = 0; i < erc20Addresses.length; i++) {
            try erc20Addresses[i].balanceOf(target) returns (uint256 _balance) {
                balances[i] = _balance;
            } catch {
                balances[i] = type(uint256).max;
            }
        }

        if (fetchDecimals) {
            decimals = new uint8[](erc20Addresses.length);
            for (uint256 i = 0; i < erc20Addresses.length; i++) {
                try erc20Addresses[i].decimals() returns (uint8 _decimals) {
                    decimals[i] = _decimals;
                } catch {}
            }
        }
        if (fetchSymbol) {
            symbols = new string[](erc20Addresses.length);
            for (uint256 i = 0; i < erc20Addresses.length; i++) {
                try erc20Addresses[i].symbol() returns (string memory _symbol) {
                    symbols[i] = _symbol;
                } catch {}
            }
        }
        if (fetchName) {
            names = new string[](erc20Addresses.length);
            for (uint256 i = 0; i < erc20Addresses.length; i++) {
                try erc20Addresses[i].name() returns (string memory _name) {
                    names[i] = _name;
                } catch {}
            }
        }
    }
}
