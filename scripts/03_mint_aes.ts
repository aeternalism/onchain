import { run, ethers } from 'hardhat';
import { utils } from 'ethers';
import configEnv from './00_config_env';
import { Aeternalism__factory as AeternalismFactory } from '../typechain';

const CONTRACT_ADDRESS = configEnv.aes_address;
const HOLDER_ADDRESS = configEnv.aesb_address;

async function main() {
  await run('compile');
  const [owner] = await ethers.getSigners();
  const ae = AeternalismFactory.connect(CONTRACT_ADDRESS, owner);

  await ae.mint(HOLDER_ADDRESS, utils.parseUnits('454125', 18));
}

main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });
  