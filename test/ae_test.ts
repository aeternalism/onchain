import { describe, it } from 'mocha';
import { expect } from 'chai';
import { Contract, utils } from 'ethers';
import { ethers } from 'hardhat';

describe('Aeternalism', () => {
  let ae: Contract;

  beforeEach(async () => {
    ae = await (
      await (await ethers.getContractFactory('Aeternalism')).deploy()
    ).deployed();
  });

  it('Minting', async () => {
    const [, receiver] = await ethers.getSigners();

    await ae.mint(receiver.address, utils.parseUnits('100000', 18));

    expect(
      utils.formatUnits(await ae.balanceOf(receiver.address), 18)
    ).to.eq('100000.0');
  });

  it('Minting by issuance contract', async () => {
    const [, receiver, issuance] = await ethers.getSigners();

    await ae.grantRole(utils.keccak256(utils.toUtf8Bytes('MINTER_ROLE')), issuance.address);
    await ae.connect(issuance).mint(receiver.address, utils.parseUnits('100000', 18));

    expect(
      utils.formatUnits(await ae.balanceOf(receiver.address), 18)
    ).to.eq('100000.0');
  });

  it('Minting exeeds 1 million cap', async () => {
    const [, receiver, issuance] = await ethers.getSigners();

    await ae.grantRole(utils.keccak256(utils.toUtf8Bytes('MINTER_ROLE')), issuance.address);

    await ae.connect(issuance).mint(receiver.address, utils.parseUnits('500000', 18));
    await expect(ae.mint(receiver.address, utils.parseUnits('500001', 18))).to.be.revertedWith('Max cap reached')
  });

});
