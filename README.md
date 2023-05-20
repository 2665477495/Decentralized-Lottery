# 🎲 Decentralized Lottery Experiment 🎲

This Ethereum contract 📜 demonstrates an experimental decentralized random number generation system, as outlined in [this Stack Exchange discussion](https://ethereum.stackexchange.com/questions/191/how-can-i-securely-generate-a-random-number-in-my-smart-contract). It is not designed for any form of gambling or any real-world application. Users 🙋‍♂️🙋‍♀️ involved in this experiment submit a hash of a chosen number and their address, reveal their numbers after a set period, and the contract processes an output 🎉 based on the XOR sum of all submitted numbers.

The contract was designed considering key trade-offs and constraints:

- To prevent unfair advantages, no user-defined value (like a blockhash, timestamp, or a user-submitted number) that can affect the outcome is used.
- The contract only generates the random number after the entry period has been closed, because everything the contract sees, the public sees.
- A delay is incorporated between the generation of the number and its use to ensure that no one can know the number before the end of that block.

## 🎯 Contract Features 🎯
1. **Contract Deployer Functions**: Certain functions can only be called by the contract deployer.
2. **Submission phase**: Users submit a hash commitment of their chosen number and their address during this period. ⏱️
3. **Reveal phase**: Users reveal their chosen numbers during this period. The contract ensures the revealed number matches the earlier submitted hash commitment. 🔎
4. **Processing Output**: After the reveal phase, the contract processes an output by XORing all the revealed numbers, and using the remainder of the division by the number of participants.

📣 Important Note 📣: This contract is a proof of concept for a decentralized approach for generating a random number. It is not intended for any form of gambling or gaming application.

[🔗 Source Reference: Ethereum Stack Exchange 🔗](https://ethereum.stackexchange.com/questions/191/how-can-i-securely-generate-a-random-number-in-my-smart-contract)

## 🚀 How to Use 🚀
1. **Contract Deployer Functions**: The deployer of the contract initiates certain operations.
2. **Start the Submission Phase**: The contract deployer starts the submission period. This period lasts for the duration specified in seconds 📨.
3. **Users Submit Hashes**: Users call `submitHash(bytes32 commitment)`. The commitment is a hash of their chosen random number and their address 📬.
4. **Start the Reveal Phase**: After the submission period, the reveal phase starts 🎭.
5. **Users Reveal Numbers**: Users call `reveal(uint randomNumber)` to reveal their chosen numbers. The contract checks the revealed number against the previously submitted hash commitment 🎤.
6. **Determine the Output**: After the reveal phase, the contract XORs all the revealed numbers to generate an output.
7. **Reset the Experiment**: After determining the output, the contract automatically resets for the next round 🔄.

## 🎈 Events 🎈
- `Submission(address indexed user)`: Emitted when a user submits their hash commitment 📩.
- `Reveal(address indexed user, uint randomNumber)`: Emitted when a user reveals their number 🎙️.
- `OutputGenerated(address indexed user, uint output)`: Emitted when an output is determined 🍾.

👩‍💻👨‍💻 Developed With Solidity ^0.8.4 👩‍💻👨‍💻

Please note: This is an

 experiment to explore the possibilities of decentralized applications and is not intended for any form of gambling or gaming purposes.
