// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
/**
✅ 1、创建一个名为Voting的合约，包含以下功能：
一个mapping来存储候选人的得票数
一个vote函数，允许用户投票给某个候选人
一个getVotes函数，返回某个候选人的得票数
一个resetVotes函数，重置所有候选人的得票数
 */
contract Voting {
    // 存储候选人地址和对应的票数
    mapping(address => uint256) private votes;
    
    // 记录用户在哪个投票轮次中投过票
    mapping(address => uint256) private lastVotedRound;
    
    // 记录所有参与投票的候选人
    address[] private candidates;
    
    // 用于跟踪投票轮次
    uint256 private votingRound;
    
    // 事件声明
    event VoteCast(address indexed voter, address indexed candidate, uint256 newVoteCount);
    event VotesReset(uint256 newVotingRound);
    
    /**
     * @dev 投票给指定的候选人
     * @param candidate 候选人地址
     */
    function vote(address candidate) public {
        require(candidate != address(0), "Cannot vote for zero address");
        require(lastVotedRound[msg.sender] < votingRound, "You have already voted in this round");
        
        // 记录投票人在当前轮次中已投票
        lastVotedRound[msg.sender] = votingRound;
        
        // 如果是候选人第一次收到投票，将其添加到候选人数组
        if (votes[candidate] == 0) {
            candidates.push(candidate);
        }
        
        // 增加候选人的票数
        votes[candidate] += 1;
        
        // 触发事件
        emit VoteCast(msg.sender, candidate, votes[candidate]);
    }
    
    /**
     * @dev 获取指定候选人的票数
     * @param candidate 候选人地址
     * @return 候选人的票数
     */
    function getVotes(address candidate) public view returns (uint256) {
        return votes[candidate];
    }
    
    /**
     * @dev 重置所有候选人的票数和投票记录
     * 注意：在实际应用中，这个函数应该有访问控制
     */
    function resetVotes() public {
        // 重置所有候选人的票数
        for (uint i = 0; i < candidates.length; i++) {
            votes[candidates[i]] = 0;
        }
        
        // 清空候选人数组
        delete candidates;
        
        // 重置所有投票记录
        // 注意：这种方式在实际应用中可能会消耗大量gas，
        // 更好的方法是使用投票轮次来跟踪
        votingRound++;
        
        // 触发事件
        emit VotesReset(votingRound);
    }
    
    /**
     * @dev 检查地址是否已经在当前投票轮次中投过票
     * @param voter 投票人地址
     * @return 是否已投票
     */
    function hasAlreadyVoted(address voter) public view returns (bool) {
        return lastVotedRound[voter] == votingRound;
    }
}