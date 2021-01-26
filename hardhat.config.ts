import { HardhatUserConfig } from 'hardhat/config';
import configEnv from './scripts/00_config_env';

import '@nomiclabs/hardhat-ethers';
import '@openzeppelin/hardhat-upgrades';
import '@nomiclabs/hardhat-waffle';
import '@nomiclabs/hardhat-solhint';
import 'hardhat-typechain';
import 'hardhat-gas-reporter';

const ROPSTEN_INFURA_ENDPOINT = process.env.ROPSTEN_INFURA_ENDPOINT;
const ROPSTEN_ACCOUNT_PRIVATE_KEY = process.env.ROPSTEN_ACCOUNT_PRIVATE_KEY;
const HOMESTEAD_INFURA_ENDPOINT = process.env.HOMESTEAD_INFURA_ENDPOINT;
const HOMESTEAD_ACCOUNT_PRIVATE_KEY = process.env.HOMESTEAD_ACCOUNT_PRIVATE_KEY;

const config : HardhatUserConfig = {
  defaultNetwork: configEnv.network,
  networks: {
    hardhat: {
      chainId: 1337
    },
    localhost: {
      chainId: 1337,
      url: 'http://127.0.0.1:8545',
    },
    ropsten: {
      chainId: 3,
      url: ROPSTEN_INFURA_ENDPOINT,
      accounts: [`0x${ROPSTEN_ACCOUNT_PRIVATE_KEY}`],
      loggingEnabled: true,
      gas: 'auto',
    },
    homestead: {
      chainId: 1,
      url: HOMESTEAD_INFURA_ENDPOINT,
      accounts: [`0x${HOMESTEAD_ACCOUNT_PRIVATE_KEY}`],
      loggingEnabled: true,
      gasPrice: 35000000000
    }
  },
  solidity: {
    version: '0.7.5',
    settings: {
      optimizer: {
        enabled: true,
        runs: 200
      }
    }
  },
  paths: {
    sources: './contracts',
    tests: './test'
  },
  typechain: {
    outDir: process.env.EXPORT_TYPECHAIN === 'true' ? '../backend/src/typechain/onchain' : 'typechain',
    target: 'ethers-v5'
  },
  gasReporter: {
    currency: 'USD',
    enabled:  process.env.REPORT_GAS === 'true' ? true : false
  }
}

export default config;
