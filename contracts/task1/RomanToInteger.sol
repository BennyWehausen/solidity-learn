// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
4、 用 solidity 实现罗马数字转数整数
 */
contract RomanToInteger {
    // 罗马数字到整数的映射
    mapping(bytes1 => uint256) private romanValues;
    
    constructor() {
        // 初始化罗马数字映射
        romanValues['I'] = 1;
        romanValues['V'] = 5;
        romanValues['X'] = 10;
        romanValues['L'] = 50;
        romanValues['C'] = 100;
        romanValues['D'] = 500;
        romanValues['M'] = 1000;
    }
    
    /**
     * @dev 将罗马数字字符串转换为整数
     * @param romanStr 罗马数字字符串
     * @return 对应的整数值
     */
    function romanToInt(string memory romanStr) public view returns (uint256) {
        bytes memory romanBytes = bytes(romanStr);
        uint256 length = romanBytes.length;
        uint256 total = 0;
        
        for (uint256 i = 0; i < length; i++) {
            uint256 currentVal = romanValues[romanBytes[i]];
            uint256 nextVal = (i < length - 1) ? romanValues[romanBytes[i + 1]] : 0;
            
            // 如果当前值小于下一个值，则减去当前值
            if (currentVal < nextVal) {
                total += nextVal - currentVal;
                i++; // 跳过下一个字符
            } else {
                total += currentVal;
            }
        }
        
        return total;
    }
    
    /**
     * @dev 验证罗马数字字符串是否有效
     * @param romanStr 罗马数字字符串
     * @return 是否有效
     */
    function isValidRoman(string memory romanStr) public view returns (bool) {
        bytes memory romanBytes = bytes(romanStr);
        uint256 length = romanBytes.length;
        
        // 检查空字符串
        if (length == 0) return false;
        
        // 检查无效字符
        for (uint256 i = 0; i < length; i++) {
            if (romanValues[romanBytes[i]] == 0) {
                return false;
            }
        }
        
        // 检查连续重复字符规则
        uint256 repeatCount = 1;
        for (uint256 i = 1; i < length; i++) {
            if (romanBytes[i] == romanBytes[i - 1]) {
                repeatCount++;
                // I, X, C, M最多连续出现3次
                // V, L, D不能重复
                if ((repeatCount > 3 && 
                    (romanBytes[i] == 'I' || romanBytes[i] == 'X' || 
                     romanBytes[i] == 'C' || romanBytes[i] == 'M')) ||
                    (repeatCount > 1 && 
                    (romanBytes[i] == 'V' || romanBytes[i] == 'L' || romanBytes[i] == 'D'))) {
                    return false;
                }
            } else {
                repeatCount = 1;
            }
        }
        
        return true; 
    }
}