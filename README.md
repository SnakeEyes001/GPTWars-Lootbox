# 🎮 GPTWars-Lootbox

**GPTWars-Lootbox** is a Web3 smart contract system built with **Solidity** and **Hardhat**, powering lootboxes for the game **GPTWars**. It features an in-game currency (GPTWarsToken, ERC20) and collectible NFTs (GPTWarsLootboxNFT, ERC721) that represent cosmetic items unlocked through lootboxes.

## 🧩 Features

- 🪙 ERC20 Token (GPTWarsToken) with mint/burn logic
- 🎁 ERC721 Lootbox NFT contract
- 🎨 Cosmetic item system with rarity levels (common, rare, epic, legendary)
- 🔄 Buy & open lootboxes with GPTWarsToken
- 📦 Randomized reward generation
- 🔐 Ownable & upgradeable-ready contract architecture

## 🛠 Tech Stack

- Solidity (>=0.8.20)
- Hardhat
- OpenZeppelin Contracts
- Ethers.js (for interaction scripts)
- Chai / Mocha (for tests)

## 📦 Installation

```bash
git clone https://github.com/your-org/GPTWars-Lootbox.git
cd GPTWars-Lootbox
npm install
