const Astrum = artifacts.require("./Astrum.sol");

module.exports = async function(deployer) {
  await deployer.deploy(Astrum);
  const erc721 = await Astrum.deployed();
};
