# Smart Contracts

Production-grade EVM-compatible Solidity contracts for IOPn Chain.

## Architecture

```
contracts/
├── SovereignModule.sol           # Base: RBAC, pause, reentrancy guards
├── CredentialIssuer.sol          # Issue/verify/revoke credentials
├── ReputationBridge.sol          # ⋂exus reputation integration
├── NeoIDVerifier.sol             # KYC/AML identity verification
├── NeoPointsManager.sol          # Gamified points system
├── REPTokenInterface.sol         # REP token rewards
└── GovernanceHub.sol             # Proposals & voting
```

## Quick Start

### Compile
```bash
npx hardhat compile
```

### Test
```bash
npx hardhat test
npx hardhat test --gas
npx hardhat coverage
```

### Deploy to Testnet
```bash
npx hardhat run scripts/deploy-testnet.js --network iopn-testnet
```

### Export ABIs
```bash
npx hardhat run scripts/export-abis.js
```

## Contracts

### 1. SovereignModule
Base contract providing:
- ✅ AccessControl (RBAC)
- ✅ Pausable (emergency pause)
- ✅ ReentrancyGuard
- ✅ Initializable (for proxy patterns)

**Roles:**
- `ADMIN_ROLE` — Full control
- `OPERATOR_ROLE` — Normal operations
- `VERIFIER_ROLE` — Identity verification

### 2. CredentialIssuer
Issue and manage verifiable credentials on-chain.

**Functions:**
- `issueCredential(recipient, type, uri, expiration)` — Issue credential
- `verifyCredential(id)` — Check if valid
- `revokeCredential(id)` — Revoke credential
- `getCredential(id)` — Get details
- `authorizeIssuer(address)` — Authorize issuer

### 3. ReputationBridge
Connect to ⋂exus reputation system.

**Functions:**
- `updateScore(user, score, evidence)` — Update reputation
- `getScore(user)` — Get score
- `linkGenesisNFT(user, tokenId)` — Link Genesis badge
- `checkGenesisStatus(user)` — Check if holder

### 4. NeoIDVerifier
KYC/AML identity verification.

**Functions:**
- `verifyIdentity(user, method)` — Mark as verified
- `isIdentityVerified(user)` — Check if verified
- `revokeVerification(user, reason)` — Revoke
- `getVerificationRecord(user)` — Get details

### 5. NeoPointsManager
Gamified points for engagement.

**Functions:**
- `awardPoints(user, points, reason)` — Award points
- `burnPoints(user, points, reason)` — Burn points
- `transferPoints(to, points)` — Transfer points
- `getUserPoints(user)` — Get balance
- `getLeaderboard(limit)` — Get top users

### 6. REPTokenInterface
REP token rewards integration.

**Functions:**
- `setREPToken(address)` — Set token contract
- `awardREP(user, amount, reason)` — Award REP
- `claimREP()` — Claim earned REP
- `getUnclaimedREP(user)` — Get balance

### 7. GovernanceHub
Decentralized governance.

**Functions:**
- `propose(description)` — Create proposal
- `castVote(proposalId, support)` — Vote (0=no, 1=yes, 2=abstain)
- `executeProposal(proposalId)` — Execute
- `getProposal(id)` — Get details

## Security

- ✅ OpenZeppelin audited
- ✅ Reentrancy guards on all state changes
- ✅ RBAC for authorization
- ✅ Pausable for emergencies
- ✅ Gas-optimized
- ✅ No external calls to untrusted contracts

## Deployment

### Testnet (OPN Chain 984)
```bash
export PRIVATE_KEY="0x..."
export RPC_URL="https://testnet-rpc.iopn.tech"
npx hardhat run scripts/deploy-testnet.js --network iopn-testnet
```

### Mainnet (When Ready)
```bash
export PRIVATE_KEY="0x..."
export MAINNET_RPC_URL="https://mainnet-rpc.iopn.tech"
npx hardhat run scripts/deploy-mainnet.js --network iopn-mainnet
```

## Gas Estimates

```
CredentialIssuer.issueCredential: ~150,000 gas
CredentialIssuer.revokeCredential: ~80,000 gas
ReputationBridge.updateScore: ~120,000 gas
NeoIDVerifier.verifyIdentity: ~140,000 gas
GovernanceHub.propose: ~200,000 gas
GovernanceHub.castVote: ~110,000 gas
```

## Testing

```bash
# Run all tests
npx hardhat test

# Run specific test file
npx hardhat test test/CredentialIssuer.test.js

# Gas reporting
REPORT_GAS=true npx hardhat test

# Coverage
npx hardhat coverage
```

## Configuration

Edit `hardhat.config.js`:

```javascript
networks: {
  "iopn-testnet": {
    url: "https://testnet-rpc.iopn.tech",
    accounts: [process.env.PRIVATE_KEY],
    chainId: 984,
  },
}
```

## License

MIT
