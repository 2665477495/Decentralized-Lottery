# 🎲 Decentralized Lottery 🎲

This Ethereum contract 📜 implements a decentralized lottery system, as outlined in [this Stack Exchange discussion](https://ethereum.stackexchange.com/questions/191/how-can-i-securely-generate-a-random-number-in-my-smart-contract). Participants 🙋‍♂️🙋‍♀️ submit a hash of their lottery number and their address, reveal their numbers after the submission period, and the contract chooses a winner 🎉 based on the XOR sum of all the submitted numbers.

The contract was designed considering key trade-offs and constraints:

- To prevent unfair advantages, no user-defined value (like a blockhash, timestamp, or a user-submitted number) that can affect the outcome is used.
- The contract only generates the random number after the lottery entry has been closed, because everything the contract sees, the public sees.
- A delay is incorporated between the generation of the number and its use to ensure that no one can know the number before the end of that block.

## 🎯 Contract Features 🎯
1. **Casino-only functions**: Certain functions can only be called by the casino 🏢 (the contract owner).
2. **Submission phase**: Participants submit a hash commitment of their chosen number and their address during this period. ⏱️
3. **Reveal phase**: Participants reveal their chosen numbers during this period. The contract ensures the revealed number matches the earlier submitted hash commitment. 🔎
4. **Winner selection**: After the reveal phase, the contract selects a winner by XORing all the revealed numbers, and using the remainder of the division by the number of participants to pick an index from the participant list. 🏆

📣 Important Note 📣: This contract follows a decentralized approach for generating the random number and determining the winner. It puts up significant security measures and incentives to discourage participants from manipulating the random number.

[🔗 Source Reference: Ethereum Stack Exchange 🔗](https://ethereum.stackexchange.com/questions/191/how-can-i-securely-generate-a-random-number-in-my-smart-contract)

## 🚀 How to Use 🚀
1. **Set the Reward**: The casino calls `setReward(uint amount)` to set the lottery reward 💰.
2. **Start the Submission Phase**: The casino calls `startSubmission(uint submissionDuration)` to begin the submission period. This period lasts for the duration specified in seconds 📨.
3. **Participants Submit Hashes**: Participants call `submitHash(bytes32 commitment)` and send an amount of ether greater than or equal to the reward. The commitment is a hash of their chosen random number and their address 📬.
4. **Start the Reveal Phase**: The casino calls `startReveal(uint revealDuration)` after the submission period to start the reveal phase 🎭.
5. **Participants Reveal Numbers**: Participants call `reveal(uint randomNumber)` to reveal their chosen numbers. The contract checks the revealed number against the previously submitted hash commitment 🎤.
6. **Determine the Winner**: After the reveal phase, the casino calls `determineWinner()`. The contract XORs all the revealed numbers, uses this to choose a winner, and transfers them the reward 🏅.
7. **Reset the Lottery**: After determining the winner, the contract automatically resets the lottery for the next round 🔄.

## 🎈 Events 🎈
- `Submission(address indexed user)`: Emitted when a user submits their hash commitment 📩.
- `Reveal(address indexed user, uint randomNumber)`: Emitted when a user reveals their number 🎙️.
- `Winner(address indexed user, uint reward)

`: Emitted when a winner is determined 🍾.

👩‍💻👨‍💻 Developed With Solidity ^0.8.4 👩‍💻👨‍💻

Remember, gambling should be fun! Don't play to make money; just play with money you can afford to lose. 🎰

Enjoy this fun, decentralized lottery contract, and may the odds be ever in your favor! 🎈
