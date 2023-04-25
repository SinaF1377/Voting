// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./SafeMath.sol";

contract FindBigestNumberOfArray {
    using SafeMath for uint256;

    function getMaxValueAndIndex(
        uint256[] memory values
    ) external pure returns (uint256, uint256) {
        require(values.length > 0, "Array must have at least one element");

        uint256 maxVal = values[0];
        uint256 maxIndex = 0;

        for (uint256 i = 1; i < values.length; i++) {
            if (values[i] > maxVal) {
                maxVal = values[i];
                maxIndex = i;
            }
        }

        return (maxVal, maxIndex);
    }
}
