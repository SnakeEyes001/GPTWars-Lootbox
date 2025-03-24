// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract GPTWarsLootboxNFT is ERC721URIStorage, Ownable {
    uint public nextTokenId = 1;
    IERC20 public gptWarsToken;
    address public gameContract;

    struct Lootbox {
        string name;
        uint lootboxLevel;
        uint price;
        string metadataURI;
    }

    struct Cosmetic {
        string name;
        string itemType;
        uint rarity;
        string metadataURI;
    }

    uint[6] public lootBoxLevel = [0, 1, 2, 3, 4, 5];

    mapping(uint => Cosmetic[]) public cosmeticSets;
    mapping(address => uint) public lootboxBalance;
    mapping(uint => Lootbox) public lootboxTypes;
    mapping(address => uint[]) public userNFTs;

    event CosmeticMinted(address indexed user, uint tokenId, string cosmeticName, string metadataURI);
    event LootboxBought(address indexed user, uint quantity, uint packType);
    event NFTEvolved(uint newTokenId, uint oldTokenId1, uint oldTokenId2, uint oldTokenId3);
    event LootboxCreated(string name, uint lootboxLevel, uint price, string metadataURI);
    event NFTCreated(address indexed user, uint tokenId, string metadataURI);
    constructor(address _gptWarsToken) ERC721("GPTWars Lootbox", "GPTLNFT") {
        gptWarsToken = IERC20(_gptWarsToken);
        _initializeLootboxes();
        _addInitialCosmetics();
    }

    function _initializeLootboxes() internal {
        lootboxTypes[0] = Lootbox("Junk Box", 0, 5 * 10**3, "ipfs://QmX4uPF7TSTXpbDwMYVDUwccv8TCvJA5KaYHwZawbxRYSN");
        lootboxTypes[1] = Lootbox("Cheap Box", 1, 15 * 10**3, "ipfs://QmNN7C2BBhHbh3KxqmWAYH8FxUDb1xshHuc5ctpBCyjujm");
        lootboxTypes[2] = Lootbox("Good Box", 2, 30 * 10**3, "ipfs://QmeWKkibVsGUaH8hWk8krMVRb5QoHv2jwbYJGAuaE5zGqU");
        lootboxTypes[3] = Lootbox("Great Box", 3, 50 * 10**3, "ipfs://QmRqNkREaiJsEGLXx1z7gHUmD6DJv2FKUGQqV5rZnLsDc8");
        lootboxTypes[4] = Lootbox("Epic Box", 4, 80 * 10**3, "ipfs://QmUZnJ8bTHFjTCqYWFHEQi6Z5P6TggG1vQLRcTfa1DByfb");
        lootboxTypes[5] = Lootbox("Legendary Box", 5, 150 * 10**3, "ipfs://QmXGzZu1B2AWxZTv1dXQkGLdxzaTeEAiPfcT4SYvJ5VCdn");
    }

    function _addInitialCosmetics() internal {
        cosmeticSets[0].push(Cosmetic("Assault Visor", "Hat", 0, "ipfs://QmWgPUtvthvkRorM9iB9XtZj5fjyhW4FeUANmcqNVqtVY1"));
        cosmeticSets[5].push(Cosmetic("Camo Snapback", "Hat", 5, "ipfs://QmcpG8jaAiNAn1UxThXNRz19WM3WUMFQGqe21jopwDnJHz"));
        cosmeticSets[1].push(Cosmetic("Combat Fedora", "Hat", 1, "ipfs://QmYwi3DgEjRFMToXt5YADF5E4dDX6vxrng6gHPTD65ZPMS"));
        cosmeticSets[2].push(Cosmetic("Dusty Cap", "Hat", 2, "ipfs://QmNUyqyaNUpDBdHEJSGqEuHEZGvyDrmZgnCZMHgTvGEqkd"));
        cosmeticSets[3].push(Cosmetic("elite-marksman-cap", "Hat", 3, "ipfs://QmS39FAZdvgpu3BZTnuTSwA9978JTVjymaEsNmUqBd3ksa"));
    }

   function _randomChance(uint lootboxlevel) internal view returns (uint) {
    uint randomNumber = uint(keccak256(abi.encodePacked(block.timestamp, msg.sender, nextTokenId))) % 1000;
    uint256[7] memory probabilities;

    if (lootboxlevel == 0) { // Junk Box
        probabilities[0] = 700;
        probabilities[1] = 900;
        probabilities[2] = 970;
        probabilities[3] = 999;
        probabilities[4] = 1000;
        probabilities[5] = 1000;
        probabilities[6] = 1000;
    } else if (lootboxlevel == 1) { // Cheap Box
        probabilities[0] = 300;
        probabilities[1] = 700;
        probabilities[2] = 930;
        probabilities[3] = 990;
        probabilities[4] = 1000;
        probabilities[5] = 1000;
        probabilities[6] = 1000;
    } else if (lootboxlevel == 2) { // Good Box
        probabilities[0] = 15;
        probabilities[1] = 115;
        probabilities[2] = 515;
        probabilities[3] = 815;
        probabilities[4] = 940;
        probabilities[5] = 990;
        probabilities[6] = 1000;
    } else if (lootboxlevel == 3) { // Great Box
        probabilities[0] = 0;
        probabilities[1] = 20;
        probabilities[2] = 100;
        probabilities[3] = 470;
        probabilities[4] = 870;
        probabilities[5] = 970;
        probabilities[6] = 1000;
    } else if (lootboxlevel == 4) { // Epic Box
        probabilities[0] = 0;
        probabilities[1] = 0;
        probabilities[2] = 10;
        probabilities[3] = 80;
        probabilities[4] = 680;
        probabilities[5] = 900;
        probabilities[6] = 1000;
    } else if (lootboxlevel == 5) { // Legendary Box
        probabilities[0] = 0;
        probabilities[1] = 0;
        probabilities[2] = 0;
        probabilities[3] = 20;
        probabilities[4] = 100;
        probabilities[5] = 720;
        probabilities[6] = 1000;
    }

    for (uint i = 0; i < probabilities.length; i++) {
        if (randomNumber < probabilities[i]) {
            return i; // Retourne le niveau de rareté du NFT
        }
    }

    return 0; // Par défaut, retourne "Pas de NFT"
}

  function createNFT(address recipient, string memory metadataURI) public onlyOwner {
        _mint(recipient, nextTokenId);
        _setTokenURI(nextTokenId, metadataURI);
        userNFTs[recipient].push(nextTokenId);
        emit NFTCreated(recipient, nextTokenId, metadataURI);
        nextTokenId++;
    }
    function buyLootboxes(uint quantity, uint lootboxlevel) public {
        uint packPrice = lootboxTypes[lootboxlevel].price;
        require(gptWarsToken.transferFrom(msg.sender, address(this), packPrice * quantity), "Payment failed");

        lootboxBalance[msg.sender] += quantity;
        emit LootboxBought(msg.sender, quantity, lootboxlevel);
    }
    function openLootbox(uint lootboxlevel) public {
    require(lootboxBalance[msg.sender] > 0, "No lootbox available");
    lootboxBalance[msg.sender]--;

    uint rarityLevel = _randomChance(lootboxlevel);

    if (rarityLevel > 0) {
        // Sélectionner un NFT de cette rareté
        Cosmetic memory selectedCosmetic = _selectCosmetic(rarityLevel);

        _mint(msg.sender, nextTokenId);
        _setTokenURI(nextTokenId, selectedCosmetic.metadataURI);
        userNFTs[msg.sender].push(nextTokenId);

        emit CosmeticMinted(msg.sender, nextTokenId, selectedCosmetic.name, selectedCosmetic.metadataURI);
        nextTokenId++;
    }
}
 function openOneLootbox(string memory name) public {
        require(lootboxBalance[msg.sender] > 0, "No lootbox available");

        uint lootboxLevel = _getLootboxLevelByName(name);
        require(lootboxLevel > 0, "Invalid lootbox name");

        lootboxBalance[msg.sender]--;

        uint rarityLevel = _randomChance(lootboxLevel);

        if (rarityLevel > 0) {
            Cosmetic memory selectedCosmetic = _selectCosmetic(rarityLevel);
            _mint(msg.sender, nextTokenId);
            _setTokenURI(nextTokenId, selectedCosmetic.metadataURI);
            userNFTs[msg.sender].push(nextTokenId);
            emit CosmeticMinted(msg.sender, nextTokenId, selectedCosmetic.name, selectedCosmetic.metadataURI);
            nextTokenId++;
        }
    }

    function _getLootboxLevelByName(string memory name) internal view returns (uint) {
        for (uint i = 0; i < 6; i++) {
            if (keccak256(bytes(lootboxTypes[i].name)) == keccak256(bytes(name))) {
                return lootboxTypes[i].lootboxLevel;
            }
        }
        return 0; // Return 0 if lootbox not found
    }


    function _selectCosmetic(uint lootboxlevel) internal view returns (Cosmetic memory) {
        uint random = uint(keccak256(abi.encodePacked(block.timestamp, msg.sender, nextTokenId))) % 1000;
        uint cumulativeProbability = 0;
        Cosmetic[] memory cosmetics = cosmeticSets[lootboxlevel];

        for (uint i = 0; i < cosmetics.length; i++) {
            cumulativeProbability += cosmetics[i].rarity;
            if (random < cumulativeProbability) {
                return cosmetics[i];
            }
        }
        return cosmetics[cosmetics.length - 1];
    }

    function getAllLootboxes() public view returns (Lootbox[] memory) {
        Lootbox[] memory allLootboxes = new Lootbox[](6);
        for (uint i = 0; i < 6; i++) {
            allLootboxes[i] = lootboxTypes[i];
        }
        return allLootboxes;
    }

    function getLootboxNFTs(address user) public view returns (uint[] memory) {
        return userNFTs[user];
    }

    function createLootbox(string memory name, uint lootboxLevel, uint price, string memory metadataURI) public onlyOwner {
        lootboxTypes[lootboxLevel] = Lootbox(name, lootboxLevel, price, metadataURI);
        emit LootboxCreated(name, lootboxLevel, price, metadataURI);
    }

    function withdraw() public onlyOwner {
        uint balance = gptWarsToken.balanceOf(address(this));
        require(gptWarsToken.transfer(owner(), balance), "Withdraw failed");
    }

    function setGameContract(address _gameContract) external onlyOwner {
        gameContract = _gameContract;
    }

    function approveGameContract(uint tokenId) public {
        require(ownerOf(tokenId) == msg.sender, "Not the owner");
        approve(gameContract, tokenId);
    }
}