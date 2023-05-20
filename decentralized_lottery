// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract DecentralizedLottery {
    struct Participant {
        bytes32 commitment;
        uint randomNumber;
    }

    address public casino;
    uint public reward;
    uint public submissionEndTime;
    uint public revealEndTime;
    mapping(address => Participant) public participants;
    address[] public participantAddresses;

    event Submission(address indexed user);
    event Reveal(address indexed user, uint randomNumber);
    event Winner(address indexed user, uint reward);

    constructor() {
        casino = msg.sender;
    }

    modifier onlyCasino() {
        require(msg.sender == casino, "Only the casino can call this function.");
        _;
    }

    modifier onlyAfterSubmissionEnd() {
        require(block.timestamp >= submissionEndTime, "Submission period has not ended yet.");
        _;
    }

    modifier onlyBeforeRevealEnd() {
        require(block.timestamp < revealEndTime, "Reveal period has ended.");
        _;
    }

    function setReward(uint amount) external onlyCasino {
        reward = amount;
    }

    function startSubmission(uint submissionDuration) external onlyCasino {
        require(submissionEndTime == 0, "Submission period has already started.");
        submissionEndTime = block.timestamp + submissionDuration;
    }

    function submitHash(bytes32 commitment) external payable {
        require(block.timestamp < submissionEndTime, "Submission period has ended.");
        require(msg.value >= reward, "Insufficient value sent.");

        participants[msg.sender] = Participant(commitment, 0);
        participantAddresses.push(msg.sender);
        emit Submission(msg.sender);
    }

    function startReveal(uint revealDuration) external onlyCasino onlyAfterSubmissionEnd {
        require(revealEndTime == 0, "Reveal period has already started.");
        revealEndTime = submissionEndTime + revealDuration;
    }

    function reveal(uint randomNumber) external onlyAfterSubmissionEnd onlyBeforeRevealEnd {
        bytes32 commitment = keccak256(abi.encodePacked(randomNumber, msg.sender));
        
        require(participants[msg.sender].commitment == commitment, "Invalid reveal.");
        participants[msg.sender].randomNumber = randomNumber;

        emit Reveal(msg.sender, randomNumber);
    }

    function determineWinner() external onlyCasino onlyAfterSubmissionEnd {
        require(block.timestamp >= revealEndTime, "Reveal period has not ended yet.");

        uint xorSum = 0;
        for(uint i = 0; i < participantAddresses.length; i++) {
            xorSum ^= participants[participantAddresses[i]].randomNumber;
        }

        uint winnerIndex = xorSum % participantAddresses.length;
        address winner = participantAddresses[winnerIndex];

        emit Winner(winner, reward);

        payable(winner).transfer(reward);
        resetLottery();
    }

    function resetLottery() private {
        reward = 0;
        submissionEndTime = 0;
        revealEndTime = 0;
        delete participantAddresses;
    }
}
