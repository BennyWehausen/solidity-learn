// SPDX-License-Identifier: MIT
pragma solidity ^0.8;
/**
2、反转字符串 (Reverse String)
题目描述：反转一个字符串。输入 "abcde"，输出 "edcba"
 */
contract reversetString{
    function reverseString(string memory _str) public pure returns (string memory) {
        bytes memory strBytes = bytes(_str);
        uint256 length = strBytes.length;
        bytes memory reversed = new bytes(length);

        for (uint256 i = 0; i < length; i++) {
            reversed[i] = strBytes[length - 1 - i]; // 从后往前填充
        }
        return string(reversed);
    }
}
