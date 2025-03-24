const GPTWarsToken = artifacts.require("GPTWarsToken");
const GPTWarsLootboxNFT = artifacts.require("GPTWarsLootboxNFT");

module.exports = async function (deployer, network, accounts) {
  if (network !== "development") {
    console.log(
      `Ce script est prévu pour Ganache (development), réseau actuel : ${network}`
    );
    return;
  }

  const ownerAddress = accounts[0];

  console.log("Début de la migration sur Ganache...");
  console.log("Compte propriétaire :", ownerAddress);

  try {
    // Déploiement du token ERC20 GPTWarsToken
    console.log("\nDéploiement de GPTWarsToken...");
    await deployer.deploy(GPTWarsToken, { from: ownerAddress });
    const gptWarsTokenInstance = await GPTWarsToken.deployed();
    console.log(
      `GPTWarsToken déployé à l'adresse : ${gptWarsTokenInstance.address}`
    );

    // Déploiement du contrat GPTWarsLootboxNFT avec l'adresse du token ERC20
    console.log("\nDéploiement de GPTWarsLootboxNFT...");
    await deployer.deploy(GPTWarsLootboxNFT, gptWarsTokenInstance.address, {
      from: ownerAddress,
    });
    const lootboxNFTInstance = await GPTWarsLootboxNFT.deployed();
    console.log(
      `GPTWarsLootboxNFT déployé à l'adresse : ${lootboxNFTInstance.address}`
    );

    // Résumé du déploiement
    console.log("Résumé du déploiement sur Ganache :");
    console.log(`GPTWarsToken : ${gptWarsTokenInstance.address}`);
    console.log(`GPTWarsLootboxNFT : ${lootboxNFTInstance.address}`);
  } catch (error) {
    console.error("Une erreur s'est produite lors de la migration :", error);
  }
};
