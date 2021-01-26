import { describe, it } from 'mocha';
import { expect } from 'chai';
import { BigNumber, utils } from 'ethers';
import { ethers } from 'hardhat';

import {
  AeCollectible,
  AeCollectible__factory as AeCollectibleFactory,
} from '../typechain';

describe('Aeternalism Collectibles', () => {
  let aec: AeCollectible;

  beforeEach(async () => {
    const [owner] = await ethers.getSigners();
    aec = await (await new AeCollectibleFactory(owner).deploy('https://metadata.aeternalism.com/{id}.json')).deployed();
  });

  it('Mint', async () => {
    const [owner] = await ethers.getSigners();

    await aec.mint(owner.address, BigNumber.from(1), BigNumber.from(100), utils.formatBytes32String(''));

    expect(
      await aec.balanceOf(owner.address, BigNumber.from(1))
    ).to.eq(BigNumber.from(100));
  });

  it('Mint twice', async () => {
    const [owner] = await ethers.getSigners();

    await aec.mint(owner.address, BigNumber.from(1), BigNumber.from(100), utils.formatBytes32String(''));

    await expect(
      aec.mint(owner.address, BigNumber.from(1), BigNumber.from(100), utils.formatBytes32String(''))
    ).to.be.revertedWith('Existed ID');
  });

  it('Mint batch', async () => {
    const [owner] = await ethers.getSigners();

    await aec.mintBatch(owner.address, [BigNumber.from(1), BigNumber.from(2)], [BigNumber.from(100), BigNumber.from(99)], utils.formatBytes32String(''));

    expect(
      await aec.balanceOf(owner.address, BigNumber.from(1))
    ).to.eq(BigNumber.from(100));
    expect(
      await aec.balanceOf(owner.address, BigNumber.from(2))
    ).to.eq(BigNumber.from(99));
  });

});
