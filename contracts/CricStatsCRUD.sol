//"SPDX-License-Identifier: UNLICENSED"

import "./Ownable.sol";
import "./SafeMath.sol";

pragma solidity ^0.6.0;

contract CricStatsCRUD is Ownable {
    
    using SafeMath for uint;

    struct CricketMatch { 
        uint cricMatchId;
        //string venue;
        //uint date;
        string vsOpponent;
        uint matchOverAmount;
        //uint runsForTeam;
        uint runsFor;
        //uint runsAgainstTeam;
        uint runsAgainst;
        //uint wicketsForTeam;
        uint wicketsFor;
        //uint wicketsAgainstTeam;
        uint wicketsAgainst;
        //uint ballsBowledTeam;
        uint ballsBowled;
        //uint ballsBattedTeam;
        uint ballsBatted;
        //uintCatches;
        //bool matchWon;
    }
    CricketMatch[] public CricketMatches;
    uint public matchesPlayed = 1;

    uint public getBattingAvg;
    uint public getBattingStrikeRate;
    //uint public totalRunsFor;
    //uint public totalBallsBatted;
    //uint public totalWicketsAgainst;
    
    uint public getBowlingAvg;
    uint public getBowlingEconomyRate;
    //uint public totalRunsAgainst;
    //uint public totalBallsBowled;
    //uint public totalWicketsFor;

    // C.R.U.D - Create
    function recordMatch(string memory vsOpponent, uint matchOverAmount, uint runsFor, uint runsAgainst, uint wicketsFor, uint wicketsAgainst, uint ballsBowled, uint ballsBatted) public onlyOwner() { 
        require(matchOverAmount >= wicketsAgainst, 'Cannot be dismissed more times than matches played');
        require(matchOverAmount > 0, 'Cannot have zero matches played');
        CricketMatches.push(CricketMatch(matchesPlayed, vsOpponent, matchOverAmount, runsFor, runsAgainst, wicketsFor, wicketsAgainst, ballsBowled, ballsBatted)); 
        matchesPlayed++;
    }

    // C.R.U.D - Read
    function viewMatch(uint cricMatchId) view public returns(uint, string memory, uint matchOverAmount, uint runsFor, uint runsAgainst, uint wicketsFor, uint wicketsAgainst, uint ballsBowled, uint ballsBatted) {
        uint i = findMatch(cricMatchId);
        return(CricketMatches[i].cricMatchId, CricketMatches[i].vsOpponent, CricketMatches[i].matchOverAmount, CricketMatches[i].runsFor, CricketMatches[i].runsAgainst, CricketMatches[i].wicketsFor, CricketMatches[i].wicketsAgainst, CricketMatches[i].ballsBowled, CricketMatches[i].ballsBatted);
    }
    
    // C.R.U.D - Update
    function rectifyMatchStats(uint cricMatchId, string memory vsOpponent, uint matchOverAmount, uint runsFor, uint runsAgainst, uint wicketsFor, uint wicketsAgainst, uint ballsBowled, uint ballsBatted) public onlyOwner() {
        require(matchOverAmount >= wicketsAgainst, 'Cannot be dismissed more times than matches played');
        require(matchOverAmount > 0, 'Cannot update stats with zero matches played.');
        uint i = findMatch(cricMatchId);
        CricketMatches[i].vsOpponent = vsOpponent;
        CricketMatches[i].matchOverAmount = matchOverAmount;
        CricketMatches[i].runsFor = runsFor;
        CricketMatches[i].runsAgainst = runsAgainst;
        CricketMatches[i].wicketsFor = wicketsFor;
        CricketMatches[i].wicketsAgainst = wicketsAgainst;
        CricketMatches[i].ballsBowled = ballsBowled;
        CricketMatches[i].ballsBatted = ballsBatted;
    }
    
    // C.R.U.D - Destroy
    function removeMatch(uint cricMatchId) public onlyOwner() {
        uint i = findMatch(cricMatchId);
        delete CricketMatches[i];
    }

    // Find a Match by index number
    function findMatch(uint cricMatchId) view internal returns(uint) {
        for(uint i = 1; i < CricketMatches.length; i++) {
            if(CricketMatches[i].cricMatchId == cricMatchId) {
                return i;
            }
        }
        revert('That Cricket Match has not been recorded.');
    }

    function setBattingAvg(uint _runsFor, uint _wicketsAgainst) public returns (uint) {
        require(_wicketsAgainst > 0, 'Can only have an average if dismissed before');
        getBattingAvg = _runsFor.div(_wicketsAgainst);
        return getBattingAvg;
    }
    
    function setBattingStrikeRate(uint _runsFor, uint _ballsBatted) public returns (uint) {
        require(_ballsBatted > 1, 'Not enough balls faced to have a strike rate');
        getBattingStrikeRate = (_runsFor.div(_ballsBatted)).mul (100);
    }

    function setBowlingAvg(uint _runsAgainst, uint _wicketsFor) public returns (uint) {
        getBowlingAvg = _runsAgainst.div(_wicketsFor);
        return getBowlingAvg;
    }
    
    function setBowlingEconomyRate(uint _runsAgainst, uint _ballsBowled) public returns(uint) {
        getBowlingEconomyRate = (_runsAgainst.div(_ballsBowled)).mul(6); // 6 balls in one over
    }

}


