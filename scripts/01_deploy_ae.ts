import { run, ethers } from 'hardhat';
import { Aeternalism__factory as AeternalismFactory } from '../typechain';

async function main() {
  await run('compile');

  const [owner] = await ethers.getSigners();
  const aeInstance = await new AeternalismFactory(owner).deploy();
  const aeContract = await aeInstance.deployed();

  console.log(`Aeternalism deployed to: ${aeContract.address}`);
}

main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });
  