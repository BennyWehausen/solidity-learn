// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract BinarySearch {
    // 二分查找实现
    function search(int256[] memory arr, int256 target) public pure returns (int256) {
        uint256 left = 0;
        uint256 right = arr.length - 1;
        while (left <= right) {
            uint256 mid = left + (right - left) / 2;
            if (arr[mid] == target) {
                 // 找到目标，返回索引
                return int256(mid);
            } else if (arr[mid] < target) {
                left = mid + 1;
            } else {
                right = mid - 1;
            }
        }
        return -1; // 未找到
    }
}
