//"SPDX-License-Identifier: UNLICENSED"

import "./Ownable.sol";
import "./SafeMath.sol";

pragma solidity ^0.6.0;

contract CricStatsCRUD is Ownable {
    
    using SafeMath for uint;

    struct CricPlayer { 
        uint cricId;
        string cricName;
        uint matchesPlayed;
        uint runsFor;
        uint runsAgainst;
        uint wicketsFor;
        uint wicketsAgainst;
    }
    
    CricPlayer[] public cricPlayers;
    uint public nextCric = 1; 
    

    function createCric(string memory cricName, uint matchesPlayed, uint runsFor, uint runsAgainst, uint wicketsFor, uint wicketsAgainst) public onlyOwner() { 
        require(matchesPlayed >= wicketsAgainst, 'Cannot be dismissed more times than matches played');
        require(matchesPlayed > 0, 'Cannot have zero matches played');
        cricPlayers.push(CricPlayer(nextCric, cricName, matchesPlayed, runsFor, runsAgainst, wicketsFor, wicketsAgainst)); 
        nextCric++;
    }

    function readCric(uint cricId) view public returns(uint, string memory, uint matchesPlayed, uint runsFor, uint runsAgainst, uint wicketsFor, uint wicketsAgainst) {
        uint i = findCric(cricId);
        return(cricPlayers[i].cricId, cricPlayers[i].cricName, cricPlayers[i].matchesPlayed, cricPlayers[i].runsFor, cricPlayers[i].runsAgainst, cricPlayers[i].wicketsFor, cricPlayers[i].wicketsAgainst);
    }
        
    function updateCric(uint cricId, string memory cricName, uint matchesPlayed, uint runsFor, uint runsAgainst, uint wicketsFor, uint wicketsAgainst) public onlyOwner() {
        require(matchesPlayed >= wicketsAgainst, 'Cannot be dismissed more times than matches played');
        require(matchesPlayed > 0, 'Cannot update stats with zero matches played.');
        uint i = findCric(cricId);
        cricPlayers[i].cricName = cricName;
        cricPlayers[i].matchesPlayed = matchesPlayed;
        cricPlayers[i].runsFor = runsFor;
        cricPlayers[i].runsAgainst = runsAgainst;
        cricPlayers[i].wicketsFor = wicketsFor;
        cricPlayers[i].wicketsAgainst = wicketsAgainst;
    }
    
    function destroyCric(uint cricId) public onlyOwner() {
        uint i = findCric(cricId);
        delete cricPlayers[i];
    }

    function findCric(uint cricId) view internal returns(uint) {
        for(uint i = 0; i < cricPlayers.length; i++) {
            if(cricPlayers[i].cricId == cricId) {
                return i;
            }
        }
        revert('Cricket Player does not exist');
    }
    
    function getBattingAvg(uint256 runsFor, uint256 wicketsAgainst) public pure returns (uint256) {
        require(wicketsAgainst > 0, 'Can only have an average if dismiised before');
        uint256 battingAvg = runsFor / wicketsAgainst;
        return battingAvg;
    }

    function getBowlingAvg(uint256 runsAgainst, uint256 wicketsFor) public pure returns (uint256) {
        uint bowlingAvg = runsAgainst / wicketsFor;
        return bowlingAvg;
    }

}


