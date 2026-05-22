# Frontend

React dApp UI for IOPn Sovereign Framework.

## Quick Start

```bash
npm install
npm run dev
```

Runs at: http://localhost:5173

## Project Structure

```
src/
├── components/          # React components
│   ├── Header.jsx
│   ├── ErrorBoundary.jsx
│   ├── LoadingSpinner.jsx
│   └── styles/
├── hooks/               # Custom React hooks
│   └── useWeb3.js
├── services/            # Business logic
│   └── web3Service.js
├── pages/               # Page components (future)
├── styles/              # Global styles
│   ├── globals.css
│   └── components.css
├── config.js            # Configuration
├── App.jsx              # Root component
└── index.jsx            # Entry point
```

## Features

✅ MetaMask & OPN Wallet Integration  
✅ Real-time Contract Interaction  
✅ Responsive Mobile-First Design  
✅ Dark Mode Support  
✅ Error Handling  
✅ Loading States  
✅ TypeScript-Ready  

## Development

### Hot Module Reload
```bash
npm run dev
```

### Build for Production
```bash
npm run build
```

### Preview Production Build
```bash
npm run preview
```

### Linting
```bash
npm run lint
```

## Configuration

Edit `.env` (or create from `.env.example`):

```env
VITE_RPC_URL=https://testnet-rpc.iopn.tech
VITE_CREDENTIAL_ISSUER_ADDRESS=0x...
VITE_REPUTATION_BRIDGE_ADDRESS=0x...
# ... other contract addresses
```

## Architecture

### Web3 Service
Centralized Web3 management:
- Wallet connection (MetaMask/OPN Wallet)
- Network switching
- Provider & signer management

### useWeb3 Hook
React hook for Web3 state:
```javascript
const { isConnected, address, connect, disconnect } = useWeb3();
```

### Components
- **Header** — Navigation and wallet connect
- **ErrorBoundary** — Global error handling
- **LoadingSpinner** — Loading states

## Styling

Uses:
- **Tailwind CSS** for utility styles
- **CSS Modules** for component scoping
- **CSS Variables** for theming

Dark mode support via `prefers-color-scheme`.

## Wallet Integration

### MetaMask
Automatically detected and used if installed.

### OPN Wallet
Custom wallet integration (coming soon).

## License

MIT
