//const Migrations = artifacts.require("Migrations");
const TOKEN_CONTRACT = artifacts.require("Shinuamai");
const NFT_CONTRACT = artifacts.require("Shinuamai2");
const STAKING_CONTRACT = artifacts.require("Staking");
module.exports = async function (deployer) {
  await deployer.deploy(TOKEN_CONTRACT);
  await deployer.deploy(NFT_CONTRACT, (await TOKEN_CONTRACT.deployed()).address);
  await deployer.deploy(STAKING_CONTRACT, (await TOKEN_CONTRACT.deployed()).address);
};
