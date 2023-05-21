// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

/// @title Decentralized Lottery Contract
/// @dev Contract to manage a decentralized lottery system
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

    /// @dev Constructor sets the casino owner of the contract
    constructor() {
        casino = msg.sender;
    }

    /// @dev Ensures that only the casino can call the function
    modifier onlyCasino() {
        require(msg.sender == casino, "Only the casino can call this function.");
        _;
    }

    /// @dev Ensures that the function can be called only after the submission period ends
    modifier onlyAfterSubmissionEnd() {
        require(block.timestamp >= submissionEndTime, "Submission period has not ended yet.");
        _;
    }

    /// @dev Ensures that the function can be called only before the reveal period ends
    modifier onlyBeforeRevealEnd() {
        require(block.timestamp < revealEndTime, "Reveal period has ended.");
        _;
    }

    /// @notice Set the reward for the lottery
    /// @param amount The reward amount
    function setReward(uint amount) external onlyCasino {
        reward = amount;
    }

    /// @notice Start the submission period for the lottery
    /// @param submissionDuration Duration of the submission period in seconds
    function startSubmission(uint submissionDuration) external onlyCasino {
        require(submissionEndTime == 0, "Submission period has already started.");
        submissionEndTime = block.timestamp + submissionDuration;
    }

    /// @notice Submit a commitment to participate in the lottery
    /// @param commitment The hashed commitment of the participant
    function submitHash(bytes32 commitment) external payable {
        require(block.timestamp < submissionEndTime, "Submission period has ended.");
        require(msg.value >= reward, "Insufficient value sent.");

        participants[msg.sender] = Participant(commitment, 0);
        participantAddresses.push(msg.sender);
        emit Submission(msg.sender);
    }

    /// @notice Start the reveal period for the lottery
    /// @param revealDuration Duration of the reveal period in seconds
    function startReveal(uint revealDuration) external onlyCasino onlyAfterSubmissionEnd {
        require(revealEndTime == 0, "Reveal period has already started.");
        revealEndTime = submissionEndTime + revealDuration;
    }

    /// @notice Reveal the random number for the lottery
    /// @param randomNumber The random number of the participant
    function reveal(uint randomNumber) external onlyAfterSubmissionEnd onlyBeforeRevealEnd {
        bytes32 commitment = keccak256(abi.encodePacked(randomNumber, msg.sender));
        
        require(participants[msg.sender].commitment == commitment, "Invalid reveal.");
        participants[msg.sender].randomNumber = randomNumber;

        emit Reveal(msg.sender, randomNumber);
    }

    /// @notice Determine the winner of the lottery
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

    /// @dev Reset the lottery game
    function resetLottery() private {
        reward = 0;
        submissionEndTime = 0;
        revealEndTime = 0;
        delete participantAddresses;
    }
}
