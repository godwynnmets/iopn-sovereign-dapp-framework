# Mosaic RWA Platform 🌍

**Sovereign RWA Tokenization Factory for IOPn OPN Chain**

## Overview

Mosaic is a comprehensive RWA (Real World Asset) tokenization platform built on the IOPn OPN Chain. It enables the fractional tokenization of real-world assets like real estate, commodities, and logistics infrastructure into tradeable digital securities.

### Key Features

✅ **UUPS Upgradeable Architecture** - Future-proof smart contracts  
✅ **Role-Based Access Control** - Admin, Issuer, and Genesis holder roles  
✅ **Dual Token Model** - NFT representations + Fractional ERC20 shares  
✅ **Genesis Holder Rewards** - 2x REP multiplier for early adopters  
✅ **Complete Test Suite** - Comprehensive Hardhat tests  
✅ **Production Ready** - Gas optimized, security audited patterns  

## Quick Start

### Installation

```bash
npm install
```

### Compilation

```bash
npm run compile
```

### Testing

```bash
npm test
```

### Deployment to Testnet

```bash
npm run deploy:testnet
```

### Deployment to Mainnet

```bash
npm run deploy:mainnet
```

## Contract Architecture

### MosaicFactory.sol
Core contract managing RWA tokenization with:
- Asset creation and management
- Role-based permissions
- REP reward system
- Proxy upgradeable pattern

### MosaicAsset.sol
ERC721 NFT contract representing whole asset ownership.

### MosaicFractionalToken.sol
ERC20 contract for fractional share distribution.

## Smart Contract Functions

### Tokenize Asset

```solidity
function tokenizeAsset(
    string memory name,
    string memory assetType,
    string memory location,
    uint256 totalShares,
    string memory tokenURI
) external returns (uint256)
```

Tokenizes a real-world asset and deploys associated NFT and fractional tokens.

**Parameters:**
- `name`: Asset name
- `assetType`: Type (RealEstate, PalmOil, Cocoa, Logistics)
- `location`: Geographic location
- `totalShares`: Number of fractional shares
- `tokenURI`: IPFS metadata URI

**Returns:** Asset ID

### Register Genesis Holder

```solidity
function registerGenesisHolder(address holder) external
```

Registers an address as a genesis holder, enabling 2x REP rewards.

### Get Asset

```solidity
function getAsset(uint256 assetId) external view returns (Asset memory)
```

Retrieves asset details by ID.

### Get Total Assets

```solidity
function getTotalAssets() external view returns (uint256)
```

Returns the total number of tokenized assets.

## Asset Structure

```solidity
struct Asset {
    uint256 assetId;              // Unique identifier
    address owner;                // Asset issuer
    string name;                  // Asset name
    string assetType;             // RealEstate, PalmOil, etc.
    string location;              // Geographic location
    uint256 totalShares;          // Fractional share count
    address nftAddress;           // ERC721 NFT address
    address fractionalToken;      // ERC20 shares address
    bool active;                  // Active status
    uint256 issuedAt;            // Timestamp
}
```

## Events

### AssetTokenized
Emitted when a new asset is tokenized.

```solidity
event AssetTokenized(
    uint256 indexed assetId,
    address indexed owner,
    string name,
    string assetType,
    string location
);
```

### REPAwarded
Emitted when REP tokens are awarded.

```solidity
event REPAwarded(
    address indexed user,
    uint256 amount,
    string reason
);
```

## Role-Based Access

- **DEFAULT_ADMIN_ROLE**: Full contract management
- **ADMIN_ROLE**: Administrative functions
- **ISSUER_ROLE**: Can tokenize assets
- **GENESIS_ROLE**: Early adopter rewards

## Environment Setup

Create `.env` file in the root directory:

```bash
PRIVATE_KEY=your_private_key_here
OPN_TESTNET_RPC=https://testnet-rpc.opnchain.io
OPN_MAINNET_RPC=https://mainnet-rpc.opnchain.io
```

⚠️ **IMPORTANT**: Never commit the `.env` file containing your private key!

## Security

✅ OpenZeppelin audited contracts  
✅ Access control patterns  
✅ Input validation  
✅ Proxy upgrade authorization  
✅ Safe math (Solidity 0.8.20+)  

## Gas Optimization

- Compiler optimization enabled with 200 runs
- Efficient counter-based asset IDs
- Minimal storage operations
- Optimized event logging

## Testing

Comprehensive test suite covering:
- Asset tokenization
- Role management
- REP reward logic
- Genesis holder benefits
- Asset retrieval

Run tests:
```bash
npm test
```

Run tests with coverage:
```bash
npm run test:coverage
```

## Project Structure

```
.
├── contracts/
│   └── MosaicFactory.sol        # Main contract with supporting contracts
├── test/
│   └── MosaicFactory.test.js     # Test suite
├── scripts/
│   └── deploy.js                 # Deployment script
├── deployments/                  # Deployment records
├── hardhat.config.js             # Hardhat configuration
├── package.json                  # Dependencies
├── .env.example                  # Environment template
└── MOSAIC_README.md              # This file
```

## Supported Networks

- **OPN Testnet** - Chain ID: 984
- **OPN Mainnet** - Chain ID: 984
- **Hardhat** - Local development

## Network Endpoints

- **OPN Testnet RPC**: https://testnet-rpc.opnchain.io
- **OPN Mainnet RPC**: https://mainnet-rpc.opnchain.io
- **Explorer**: https://explorer.opnchain.io

## Post-Deployment

### Register Genesis Holders

```javascript
const mosaicFactory = await ethers.getContractAt(
  "MosaicFactory",
  "0x_deployed_address"
);

await mosaicFactory.registerGenesisHolder("0x_holder_address");
```

### Tokenize First Asset

```javascript
const tx = await mosaicFactory.tokenizeAsset(
  "Real Estate Property",
  "RealEstate",
  "Lagos, Nigeria",
  1000,
  "ipfs://QmXXXXXX"
);

const receipt = await tx.wait();
console.log("Asset tokenized with ID: 0");
```

### Upgrade the Contract (UUPS)

To upgrade the contract in the future:

1. Modify `MosaicFactory.sol`
2. Create new deployment script:

```javascript
const PROXY_ADDRESS = "0x...";
const MosaicFactoryV2 = await ethers.getContractFactory("MosaicFactory");
await upgrades.upgradeProxy(PROXY_ADDRESS, MosaicFactoryV2);
```

## Troubleshooting

### Compilation Errors
```bash
npm run clean
npm install
npm run compile
```

### Test Failures
- Ensure all dependencies are installed
- Check that Hardhat is configured correctly
- Verify network settings in hardhat.config.js

### Deployment Issues
- Check `.env` file is properly configured
- Verify private key has sufficient OPN testnet funds
- Ensure RPC endpoints are accessible

## Contributing

Contributions are welcome! Please follow these guidelines:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

MIT License - see LICENSE file for details

## Author

**Genesis n-Badge Holder**  
Address: 0x317074C86d87c378df1E4264FD855c13AA6192a0

## Acknowledgments

- OpenZeppelin for secure smart contract libraries
- IOPn for the OPN Chain infrastructure
- Hardhat for the development environment

## Resources

- [OPN Chain Docs](https://docs.opnchain.io)
- [OpenZeppelin Docs](https://docs.openzeppelin.com)
- [Solidity Docs](https://docs.soliditylang.org)
- [Hardhat Docs](https://hardhat.org)

## Support

For issues, questions, or suggestions:
- Open an issue on GitHub
- Create a discussion in the repository

---

**Built with ❤️ for the IOPn OPN Chain Community**
