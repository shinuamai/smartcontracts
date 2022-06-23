const TOKEN_CONTRACT = artifacts.require("Shinuamai");
const NFT_CONTRACT = artifacts.require("Shinuamai2");
const STAKING_CONTRACT = artifacts.require("Staking");
const { expectEvent, expectRevert, time, BN } = require('@openzeppelin/test-helpers');

const { assert } = require('chai');

contract('Contract721', ([alice, bob, peter, owner]) => {
  before(async () => {
    this.TOKEN = await TOKEN_CONTRACT.new({ from: owner });
    this.NFT = await NFT_CONTRACT.new(this.TOKEN.address, { from: owner });
    await this.TOKEN.mint(alice);
  })
  it("check owner is set correctly", async () => {
    assert.equal(await this.NFT.owner(), owner);
    assert.equal(await this.TOKEN.owner(), owner);
  })
  // it("check change token price", async () => {
  //   await this.NFT.setTokenPrice(3, { from: owner });

  // })
  it("check change token price different to owner", async () => {
    await expectRevert(this.NFT.setTokenPrice(4, { from: bob }), "Ownable: caller is not the owner");

  })
  it("check mint token", async () => {
    await this.TOKEN.approve(this.NFT.address, 12)
    const mintReceipt = await this.NFT.mintToken({ from: alice });
    await expectEvent(mintReceipt, "Transfer", { to: alice, tokenId: '0' });
    assert.equal(await this.NFT.balanceOf(alice), 1);
    //console.log(await this.TOKEN.balanceOf(alice));
  })

});

contract('StakingContract', ([peter, owner]) => {
  before(async () => {
    this.TOKEN = await TOKEN_CONTRACT.new({ from: owner });
    this.NFT = await NFT_CONTRACT.new(this.TOKEN.address, { from: owner });
    this.STAKING = await STAKING_CONTRACT.new(this.TOKEN.address, { from: owner });
    await this.TOKEN.mint(peter);
  })
  it("check staking user is set correctly", async () => {
    await expectRevert(this.TOKEN.setStakingContract(this.STAKING.address, {from: peter}), "Ownable: caller is not the owner");
  })
  it('deposit some token', async () => {
    await this.STAKING.deposiToken(15, {from: peter});
    assert.equal(await this.TOKEN.balanceOf(peter), 1);
  })
  it('get rewards for the deposit', async () => {
    await this.STAKING.getRewards({from: peter});
    
  })
  it('retrieve tokens', async () => {
    await this.STAKING.retrieve({from: peter});
  })
});
