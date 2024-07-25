// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract Citizen {
   struct Candidate {
        string name;
        uint256 voteCount;
    }
    struct Agenda{
        string name;
        string desc;
        uint256 voteAgenda;
    }
    mapping(address => bool) public voters;
    mapping(uint256 => Agenda) public agendas;
    mapping(address => bool) public AgendaVoted;
    uint256 public agendaCount;

    Candidate[] public candidates;
    address owner;
    

    uint256 public votingStart;
    uint256 public votingEnd;

    constructor(string[] memory _candidateNames, uint256 _durationInMinutes) {
    for (uint256 i = 0; i < _candidateNames.length; i++) {
        candidates.push(Candidate({
            name: _candidateNames[i],
            voteCount: 0
        }));
    }
    owner = msg.sender;
    votingStart = block.timestamp;
    votingEnd = block.timestamp + (_durationInMinutes * 1 minutes);
    agendaCount = 0;
}

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    function addCandidate(string memory _name) public onlyOwner {
        candidates.push(Candidate({
                name: _name,
                voteCount: 0
        }));
    }
    //THIS IS REQD
    function vote(uint256 _candidateIndex) public {
        require(!voters[msg.sender], "You have already voted.");
        require(_candidateIndex < candidates.length, "Invalid candidate index.");

        candidates[_candidateIndex].voteCount++;
        voters[msg.sender] = true;
    }
    //THIS IS REQD
    function getAllVotesOfCandiates() public view returns (Candidate[] memory){
        return candidates;
    }
    //THIS IS REQD
    function getVotingStatus() public view returns (bool) {
        return (block.timestamp >= votingStart && block.timestamp < votingEnd);
    }
    //THIS IS REQD
    function getRemainingTime() public view returns (uint256) {
        require(block.timestamp >= votingStart, "Voting has not started yet.");
        if (block.timestamp >= votingEnd) {
            return 0;
        }
        return votingEnd - block.timestamp;
    }
    function addAgenda(string memory _name, string memory _desc) public {
        agendaCount++;
        agendas[agendaCount] = Agenda({
            name: _name,
            desc: _desc,
            voteAgenda: 0
        });
    }
    function voteAgenda(uint256 _agendaID) public {
        require(!AgendaVoted[msg.sender], "You have already voted.");
        require(_agendaID > 0 && _agendaID <= agendaCount, "Invalid candidate index.");

        agendas[_agendaID].voteAgenda++;
        AgendaVoted[msg.sender] = true;
    }
    function getAllAgendas() public view returns (Agenda[] memory) {
        Agenda[] memory result = new Agenda[](agendaCount);
        for (uint256 i = 1; i <= agendaCount; i++) {
            Agenda storage agenda = agendas[i];
            result[i - 1] = agenda;
        }
        return result;
    }
}