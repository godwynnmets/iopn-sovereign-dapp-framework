# Architecture

Comprehensive design patterns and architecture for IOPn Sovereign dApp Framework.

## System Overview

```
┌─────────────────────────────────────────────────────┐
│                   Frontend (React)                   │
│  - Wallet Connection (MetaMask, OPN Wallet)         │
│  - Contract Interaction                              │
│  - Identity Verification UI                          │
│  - Dashboard & Analytics                             │
└────────────────┬────────────────────────────────────┘
                 │
         ┌───────┴─────────┐
         │                 │
         ▼                 ▼
    ┌─────────┐      ┌──────────────┐
    │ Web3.js │      │ External APIs│
    │ Ethers  │      │ NeoID, Nexus │
    └────┬────┘      └──────┬───────┘
         │                  │
         └──────────┬───────┘
                    │
              ┌─────▼─────────────────────┐
              │   OPN Chain (Testnet)     │
              │   Chain ID: 984           │
              │   RPC: testnet-rpc...     │
              └─────┬─────────────────────┘
                    │
         ┌──────────┴──────────────────┐
         │                             │
         ▼                             ▼
    ┌──────────────┐        ┌─────────────────┐
    │ Contracts    │        │ External Systems│
    │ - Sovereign  │        │ - NeoID         │
    │ - Credential │        │ - ⋂exus Nexus   │
    │ - Reputation │        │ - OPN Swap      │
    │ - Governance │        │ - Faucet        │
    └──────────────┘        └─────────────────┘
```

## Smart Contract Architecture

### Base: SovereignModule

All contracts inherit from `SovereignModule`:

```solidity
abstract contract SovereignModule is
    AccessControl,
    Pausable,
    ReentrancyGuard,
    Initializable
```

**Provides:**
- ✅ Role-Based Access Control (RBAC)
- ✅ Emergency pause mechanism
- ✅ Reentrancy protection
- ✅ Proxy-safe initialization

**Roles:**
- `ADMIN_ROLE` — Full control, governance
- `OPERATOR_ROLE` — Normal operations
- `VERIFIER_ROLE` — Verification actions

### Core Modules

#### 1. CredentialIssuer
**Purpose:** Issue and manage verifiable credentials

**Key Functions:**
- `issueCredential()` — Create new credential
- `verifyCredential()` — Check if valid & not expired
- `revokeCredential()` — Revoke credential
- `getCredential()` — Get full details

**Data Structures:**
```solidity
struct Credential {
    uint256 id;
    address issuer;
    address recipient;
    string credentialType;
    uint256 issuedAt;
    uint256 expiresAt;
    string metadataURI;
    bool revoked;
}
```

**Events:**
- `CredentialIssued(id, issuer, recipient, type, expiresAt)`
- `CredentialRevoked(id, revoker)`
- `CredentialVerified(id, verifier)`

#### 2. ReputationBridge
**Purpose:** Connect to ⋂exus reputation system

**Key Functions:**
- `updateScore()` — Update user reputation
- `getScore()` — Get current score
- `linkGenesisNFT()` — Link Genesis badge
- `checkGenesisStatus()` — Check if holder

**Data Structures:**
```solidity
struct ReputationScore {
    uint256 score;
    uint256 lastUpdated;
    address updatedBy;
    string evidence;
}
```

#### 3. NeoIDVerifier
**Purpose:** KYC/AML identity verification

**Key Functions:**
- `verifyIdentity()` — Mark as verified
- `isIdentityVerified()` — Check if verified & not expired
- `revokeVerification()` — Revoke verification
- `setVerificationExpiry()` — Configure expiration

**Statuses:**
- `UNVERIFIED` — Not yet verified
- `PENDING` — Verification in progress
- `VERIFIED` — Verified and active
- `REJECTED` — Verification failed
- `EXPIRED` — Verification expired

#### 4. NeoPointsManager
**Purpose:** Gamified engagement points

**Key Functions:**
- `awardPoints()` — Award points to user
- `burnPoints()` — Burn/deduct points
- `transferPoints()` — User-to-user transfer
- `getLeaderboard()` — Get top users

#### 5. REPTokenInterface
**Purpose:** REP token rewards integration

**Key Functions:**
- `setREPToken()` — Configure token contract
- `awardREP()` — Award REP tokens
- `claimREP()` — Claim earned tokens
- `getUnclaimedREP()` — Get balance

#### 6. GovernanceHub
**Purpose:** Decentralized governance

**Key Functions:**
- `propose()` — Create proposal
- `castVote()` — Vote (0=no, 1=yes, 2=abstain)
- `executeProposal()` — Execute if passed
- `cancelProposal()` — Cancel proposal

**Vote Types:**
- `0` — Against
- `1` — For
- `2` — Abstain

## Frontend Architecture

### React Component Hierarchy

```
App
├── ErrorBoundary
├── Header
│   ├── Navigation
│   └── WalletConnect
└── MainContent
    ├── Pages
    │   ├── Home
    │   ├── Credentials
    │   ├── Reputation
    │   └── Governance
    └── Shared Components
        ├── LoadingSpinner
        ├── Modal
        └── Forms
```

### State Management

**Web3Service (Singleton)**
- Manages wallet connection
- Provides provider & signer
- Handles network switching

**useWeb3 Hook**
```javascript
const {
  isConnected,
  address,
  loading,
  error,
  connect,
  disconnect
} = useWeb3();
```

### Data Flow

```
User Action
    ↓
Component (e.g., CredentialForm)
    ↓
Hook (useWeb3, useContract)
    ↓
Service (web3Service, contractService)
    ↓
Ethers.js → Web3 Provider
    ↓
Smart Contract
    ↓
OPN Chain (Blockchain)
    ↓
Response → Component State → UI Update
```

## Security Model

### Access Control

```
ADMIN_ROLE
├── Pause/Unpause
├── Grant/Revoke Roles
├── Set Parameters
└── Emergency Actions

OPERATOR_ROLE
├── Issue Credentials
├── Update Reputation
├── Award Points
└── Verify Identities

VERIFIER_ROLE
└── Verify Identities
```

### Reentrancy Protection

All state-changing functions use `nonReentrant`:

```solidity
function issueCredential(...) external nonReentrant returns (uint256) {
    // ... implementation
}
```

### Emergency Pause

All critical operations check for pause state:

```solidity
function issue(...) external nonReentrant whenNotPaused {
    // ...
}
```

## Data Persistence

### On-Chain (Smart Contracts)
- Credentials (immutable ledger)
- Reputation scores (mutable)
- Verification records (time-locked)
- NeoPoints balances
- Governance proposals & votes

### Off-Chain (External)
- User profiles (NeoID)
- Metadata URIs (IPFS)
- Reputation history (⋂exus)
- Analytics (backend)

## Integration Points

### NeoID (Identity)
```javascript
// Frontend
const { isVerified, kycStatus } = await neoIDService.verifyIdentity(address);

// Smart Contract (gated)
require(neoIDVerifier.isIdentityVerified(msg.sender), "Not verified");
```

### ⋂exus Reputation
```javascript
// Fetch reputation score
const score = await nexusAPI.getUserReputation(address);

// Update on-chain
reputation.updateScore(user, score, evidence);
```

### OPN Swap
```javascript
// Price feed
const rate = await swapService.getExchangeRate('OPN', 'USDC');
```

### Faucet
```javascript
// Testnet gas drip
const txHash = await faucetService.requestTokens(address, amount);
```

## Deployment Flow

```
1. Compile Contracts
   ↓
2. Run Tests
   ↓
3. Deploy to Testnet
   ├── Deploy SovereignModule (base)
   ├── Deploy CredentialIssuer
   ├── Deploy ReputationBridge
   ├── Deploy NeoIDVerifier
   ├── Deploy NeoPointsManager
   ├── Deploy REPTokenInterface
   └── Deploy GovernanceHub
   ↓
4. Initialize Contracts
   ├── Grant roles
   ├── Set parameters
   └── Link dependencies
   ↓
5. Export ABIs
   ↓
6. Update Frontend Configuration
   ↓
7. Deploy Frontend
   ├── Build static files
   └── Deploy to hosting
```

## Error Handling

### Smart Contracts
```solidity
require(condition, "Error message");
revert CustomError();
```

### Frontend
```javascript
try {
  const result = await contract.method();
} catch (error) {
  // Handle: user rejection, network error, contract revert
  console.error(error);
}
```

### React Error Boundary
Catches and logs component render errors.

## Gas Optimization

- ✅ Minimize storage writes
- ✅ Use mappings instead of arrays for lookups
- ✅ Batch operations where possible
- ✅ Avoid external calls in loops
- ✅ Use events for logging instead of storage

## Testnet → Mainnet Readiness

See [TESTNET_MAINNET_MIGRATION.md](./TESTNET_MAINNET_MIGRATION.md) for:
- State migration strategy
- Contract upgrade paths
- Governance coordination
- Launch checklist

---

**Questions?** See [README](../README.md) or open [GitHub issue](https://github.com/godwynnmets/iopn-sovereign-dapp-framework/issues)
