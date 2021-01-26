import { describe, it } from 'mocha';
import { expect } from 'chai';
import { BigNumber, utils } from 'ethers';
import { ethers } from 'hardhat';

import {
  Aeternalism,
  Aeternalism__factory as AeternalismFactory,
  AeCollectible,
  AeCollectible__factory as AeCollectibleFactory,
  AeMarket,
  AeMarket__factory as AeMarketFactory,
  ExchangeV1,
  ExchangeV1__factory as ExchangeV1Factory
} from '../typechain';

describe('Aeternalism Market', () => {
  let ae: Aeternalism;
  let aec: AeCollectible;
  let aem: AeMarket;
  let ex: ExchangeV1;

  let ae_address: string;
  let aec_address: string;
  let ex_address: string;

  beforeEach(async () => {
    const [owner] = await ethers.getSigners();
    ae = await(await new AeternalismFactory(owner).deploy()).deployed();
    ae_address = ae.address;
    aec = await (await new AeCollectibleFactory(owner).deploy("https://metadata.aeternalism.com/collectibles/{id}.json")).deployed();
    aec_address = aec.address;
    aem = await (await new AeMarketFactory(owner).deploy()).deployed();
    await aem.setCollectible(aec_address, true);

    ex = await (await new ExchangeV1Factory(owner).deploy()).deployed();
    ex_address = ex.address;

    await aem.setOperatorAddress(ex_address);
  });

  // it('Set collectible', async () => {

  // })

  // it('Create collectible', async () => {
  
  // })

  // it('Mint collectible', async () => {
  //   const [,minter] = await ethers.getSigners();
  //   await aem.connect(minter).mintCollectible(aec_address, 1, BigNumber.from(100));
  //   expect(
  //     await aec.balanceOf(minter.address, BigNumber.from(1))
  //   ).to.eq(BigNumber.from(100));
  // })

  // it('Mint abitrary collectible', async () => {
  //   const [,minter] = await ethers.getSigners();
  //   let _aec = await (await new AeternalismCollectibleFactory(minter).deploy("https://arbitrarycollectible.com/collectibles/{id}.json")).deployed();
  //   let _aec_address = _aec.address;

  //   await expect(
  //     aem.connect(minter).mintCollectible(_aec_address, 1, BigNumber.from(100))
  //   ).to.be.revertedWith('Not supported collectible');
  // })

  it('Purchase ERC1155 collectible by AES', async () => {
    const [owner ,buyer] = await ethers.getSigners();
    await aem.mintCollectible(aec_address, 1, BigNumber.from(100));
    await aec.setApprovalForAll(ex_address, true);

    await ae.mint(buyer.address, utils.parseUnits('100', 18));
    await ae.connect(buyer).approve(ex_address, utils.parseUnits('100', 18));

    expect(await aec.isApprovedForAll(owner.address, ex_address)).to.eq(true);

    await
      ex
      .connect(buyer)
      .purchaseOne({
        owner: owner.address,
        buyer: buyer.address,
        sellAsset: {
          assetType: BigNumber.from(3), // ERC1155
          token: aec_address,
          tokenId: BigNumber.from(1)
        },
        sellAmount: 10,
        orderType: 0,
        returnAsset: {
          assetType: BigNumber.from(1), // ERC20
          token: ae_address,
          tokenId: BigNumber.from(0)
        },
        returnAmount: 100,
        hashMessage: 'aaaa',
        fee: BigNumber.from(5)
      })
  })

});
