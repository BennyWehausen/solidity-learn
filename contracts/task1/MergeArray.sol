// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MergeArray{
    function mergeSortedArrays(
        uint256[] memory arr1,
        uint256[] memory arr2
    ) public pure returns (uint256[] memory) {
        uint256[] memory merged = new uint256[](arr1.length + arr2.length);
        uint256 i = 0;
        uint256 j = 0;
        uint256 k = 0;
        
        while (i < arr1.length && j < arr2.length) {
            if (arr1[i] < arr2[j]) {
                merged[k++] = arr1[i++];
            } else {
                merged[k++] = arr2[j++];
            }
        }
        
        while (i < arr1.length) {
            merged[k++] = arr1[i++];
        }
        
        while (j < arr2.length) {
            merged[k++] = arr2[j++];
        }
        
        return merged;
    }
}
