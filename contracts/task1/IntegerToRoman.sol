// SPDX-License-Identifier: MIT
pragma solidity  ^0.8.20;
/**
 3、用 solidity 实现整数转罗马数字
 */
contract OptimizedIntegerToRoman {
    uint256[13] private VALUES= [1000, 900, 500, 400, 100, 90, 50, 40, 10, 9, 5, 4, 1];
    string[13] private SYMBOLS;
    constructor() {
        SYMBOLS = [
            "M", "CM", "D", "CD",
            "C", "XC", "L", "XL",
            "X", "IX", "V", "IV", "I"
        ];
    }

    /**
     * @param num 要转换的整数
     * @return roman 罗马数字字符串
     * @notice 输入必须> 0 范围内
     */
    function intToRoman(uint256 num) public view returns (string memory roman) {
        require(num > 0 , "Invalid input >0");
        
        // 预分配足够的内存空间
        bytes memory buffer = new bytes(16); // 最长罗马数字"MMMCMXCIX"(3999)需要9字符
        
        uint256 bufferIndex;
        uint256 remaining = num;
        
        for (uint256 i = 0; i < VALUES.length; i++) {
            while (remaining >= VALUES[i]) {
                // 将符号写入buffer
                bytes memory symbolBytes = bytes(SYMBOLS[i]);
                for (uint256 j = 0; j < symbolBytes.length; j++) {
                    buffer[bufferIndex++] = symbolBytes[j];
                }
                remaining -= VALUES[i];
            }
        }
        
        // 只返回实际使用的buffer部分
        assembly {
            mstore(buffer, bufferIndex)
        }
        
        return string(buffer);
    }
}