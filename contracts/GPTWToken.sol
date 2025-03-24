// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract GPTWarsToken is ERC20, Ownable {
    uint256 public constant INITIAL_SUPPLY = 1_000_000_000 * 10**18; // 1 million de tokens

    constructor() ERC20("GPTWars Token", "GPT") {
        _mint(msg.sender, INITIAL_SUPPLY); // Mint initial au déploiement
    }

    /**
     * @dev Fonction pour que le propriétaire puisse mint de nouveaux tokens.
     * @param to Adresse qui recevra les nouveaux tokens.
     * @param amount Montant de tokens à minter.
     */
    function mint(address to, uint256 amount) external onlyOwner {
        _mint(to, amount);
    }

    /**
     * @dev Fonction pour que le propriétaire puisse brûler des tokens.
     * @param amount Montant de tokens à brûler.
     */
    function burn(uint256 amount) external {
        _burn(msg.sender, amount);
    }
}
