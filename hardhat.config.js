require('@nomicfoundation/hardhat-toolbox');
require('@openzeppelin/hardhat-upgrades');
require('dotenv').config();

const PRIVATE_KEY = process.env.PRIVATE_KEY || '0x0000000000000000000000000000000000000000000000000000000000000000';
const OPN_TESTNET_RPC = process.env.OPN_TESTNET_RPC || 'https://testnet-rpc.opnchain.io';
const OPN_MAINNET_RPC = process.env.OPN_MAINNET_RPC || 'https://mainnet-rpc.opnchain.io';

module.exports = {
  solidity: {
    version: '0.8.20',
    settings: {
      optimizer: {
        enabled: true,
        runs: 200
      }
    }
  },
  networks: {
    'opn-testnet': {
      url: OPN_TESTNET_RPC,
      accounts: [PRIVATE_KEY],
      chainId: 984
    },
    'opn-mainnet': {
      url: OPN_MAINNET_RPC,
      accounts: [PRIVATE_KEY],
      chainId: 984
    }
  },
  paths: {
    sources: './contracts',
    tests: './test',
    cache: './cache',
    artifacts: './artifacts'
  }
};
