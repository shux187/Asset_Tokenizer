# Asset-Tokenization

> A Real-World Asset (RWA) tokenization protocol built with Foundry, Solidity, and Chainlink — bringing off-chain assets on-chain through verifiable data feeds and decentralized computation.

[![Solidity](https://img.shields.io/badge/Solidity-^0.8.20-363636?logo=solidity)](https://soliditylang.org/)
[![Foundry](https://img.shields.io/badge/Built%20with-Foundry-orange)](https://book.getfoundry.sh/)
[![Chainlink](https://img.shields.io/badge/Powered%20by-Chainlink-375BD2?logo=chainlink)](https://chain.link/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Status](https://img.shields.io/badge/status-in--development-yellow)]()

---

## Overview

**Asset-Tokenization** is a smart contract system that issues ERC-20 tokens representing ownership claims over real-world assets (RWAs). The protocol uses **Chainlink Functions** to fetch verifiable off-chain data (asset valuations, custody attestations, brokerage balances) and **Chainlink Price Feeds** to ensure on-chain pricing reflects real-world market conditions.

The system supports three core RWA models:

- **On-chain collateralized assets** — backed by crypto collateral held in smart contracts
- **Synthetic assets** — price-tracking tokens without direct asset backing
- **Backed assets** — fully backed by off-chain real-world holdings (e.g., equities, commodities, treasuries) with proof-of-reserve

> This project is being developed as a learning implementation following Patrick Collins' [RWA tokenization guide](https://www.youtube.com/watch?v=KNUchSEtQV0) on the Chainlink YouTube channel.

---

## Motivation

Real-world asset tokenization is one of the most promising frontiers of blockchain technology, with institutions like BlackRock, Franklin Templeton, and major banks now actively bringing assets on-chain. This project explores the engineering primitives behind that movement — particularly the **oracle problem**: how do you prove that the off-chain asset actually exists, and how do you keep its on-chain representation honestly priced?

For African markets specifically, RWA tokenization offers a pathway to fractional ownership of traditionally illiquid assets (real estate, agricultural commodities, government securities), opening capital markets to retail participants.

---

## Architecture

```
┌─────────────────┐         ┌──────────────────────┐         ┌─────────────────┐
│                 │         │                      │         │                 │
│   User / DApp   │────────▶│  RWA Token Contract  │◀────────│   Chainlink     │
│                 │  mint/  │      (ERC-20)        │  data/  │   Functions     │
│                 │  redeem │                      │  price  │   Price Feeds   │
└─────────────────┘         └──────────┬───────────┘         └────────┬────────┘
                                       │                              │
                                       │                              │
                                       ▼                              ▼
                            ┌──────────────────────┐         ┌─────────────────┐
                            │  Collateral / Vault  │         │  Off-chain API  │
                            │       Manager        │         │  (broker, NAV,  │
                            │                      │         │   custodian)    │
                            └──────────────────────┘         └─────────────────┘
```

---

## Tech Stack

| Layer                | Technology                                                  |
|----------------------|-------------------------------------------------------------|
| Smart Contracts      | Solidity ^0.8.20                                            |
| Development Framework| [Foundry](https://book.getfoundry.sh/) (forge, cast, anvil) |
| Oracle Network       | Chainlink Functions, Chainlink Price Feeds                  |
| Token Standard       | ERC-20 (OpenZeppelin)                                       |
| Libraries            | `chainlink-brownie-contracts`, `openzeppelin-contracts`     |
| Testing              | Foundry (`forge test`), fuzz testing                        |
| Target Networks      | Ethereum Sepolia, Avalanche Fuji (testnets)                 |

---

## Project Status

This project is **actively in development**. Current progress:

- [x] Project scaffolding with Foundry
- [x] Chainlink Brownie Contracts integration
- [ ] Core ERC-20 RWA token contract
- [ ] Chainlink Functions integration for off-chain data fetching
- [ ] Chainlink Price Feeds integration
- [ ] Mint request flow
- [ ] Redeem request flow
- [ ] Collateral management
- [ ] Comprehensive test suite
- [ ] Testnet deployment scripts
- [ ] Frontend interface

---

## Getting Started

### Prerequisites

- [Foundry](https://book.getfoundry.sh/getting-started/installation) (`forge`, `cast`, `anvil`)
- [Git](https://git-scm.com/)
- An Ethereum wallet (MetaMask) with testnet ETH
- A Chainlink Functions subscription ([create one here](https://functions.chain.link/))

### Installation

Clone the repository:

```bash
git clone https://github.com/DevKay/Asset-Tokenization.git
cd Asset-Tokenization
```

Install dependencies:

```bash
forge install smartcontractkit/chainlink-brownie-contracts@0.8.0
forge install OpenZeppelin/openzeppelin-contracts
```

Build the contracts:

```bash
forge build
```

Run the test suite:

```bash
forge test -vvv
```

### Environment Variables

Create a `.env` file in the project root:

```bash
SEPOLIA_RPC_URL=https://eth-sepolia.g.alchemy.com/v2/YOUR_API_KEY
PRIVATE_KEY=0xyour_private_key_here
ETHERSCAN_API_KEY=your_etherscan_key
CHAINLINK_SUBSCRIPTION_ID=your_functions_subscription_id
```

Load them with:

```bash
source .env
```

---

## Usage

### Local Development

Start a local Anvil node:

```bash
anvil
```

Deploy contracts locally:

```bash
forge script script/Deploy.s.sol --rpc-url http://localhost:8545 --broadcast
```

### Testnet Deployment

Deploy to Sepolia:

```bash
forge script script/Deploy.s.sol \
    --rpc-url $SEPOLIA_RPC_URL \
    --private-key $PRIVATE_KEY \
    --broadcast \
    --verify
```

---

## How It Works

### 1. Minting Tokens

A user requests to mint RWA tokens by depositing collateral (or proving off-chain asset ownership). The contract triggers a **Chainlink Functions** request that:

1. Calls the broker/custodian API to verify the user's off-chain holdings
2. Returns the verified balance on-chain via DON consensus
3. Mints the corresponding amount of RWA tokens to the user

### 2. Price Discovery

**Chainlink Price Feeds** provide tamper-proof price data, ensuring the on-chain token value tracks the real-world asset price accurately. This is essential for collateralization ratios, redemption pricing, and liquidations.

### 3. Redemption

Users burn their RWA tokens to redeem the underlying value. The contract uses Chainlink Functions again to instruct the off-chain custodian to release funds (e.g., sell the share, wire fiat) and confirms settlement before completing the burn.

---

## Project Structure

```
Asset-Tokenization/
├── src/                    # Solidity source contracts
│   └── (in progress)
├── script/                 # Foundry deployment scripts
├── test/                   # Unit and integration tests
├── lib/                    # Installed dependencies (gitignored)
│   ├── chainlink-brownie-contracts/
│   └── openzeppelin-contracts/
├── foundry.toml            # Foundry configuration
├── remappings.txt          # Import remappings
└── README.md
```

---

## Security Considerations

> ⚠️ **This is educational/experimental code. Do not deploy to mainnet or use with real funds.**

Production RWA systems require:

- Independent smart contract audits
- Proof-of-Reserve mechanisms for backed assets
- Legal frameworks for off-chain enforceability
- KYC/AML compliance layers
- Robust circuit breakers and pause mechanisms
- Multi-sig governance for upgrades

---

## Roadmap

- **Phase 1** — Core tokenization contracts + Chainlink Functions integration *(current)*
- **Phase 2** — Synthetic asset module with Price Feeds
- **Phase 3** — Backed asset module with Proof-of-Reserve
- **Phase 4** — Cross-chain RWA transfers via Chainlink CCIP
- **Phase 5** — Frontend dApp + testnet showcase

---

## Resources

- [Patrick Collins — RWA Tokenization Guide](https://www.youtube.com/watch?v=KNUchSEtQV0)
- [Chainlink Functions Documentation](https://docs.chain.link/chainlink-functions)
- [Chainlink Price Feeds](https://docs.chain.link/data-feeds/price-feeds)
- [Foundry Book](https://book.getfoundry.sh/)
- [OpenZeppelin Contracts](https://docs.openzeppelin.com/contracts/)

---

## License

This project is licensed under the MIT License — see the [LICENSE](LICENSE) file for details.

---

## Author

**Mushuka Mulenga** (DevKay)
Computer Science Student — ZCAS University, Lusaka, Zambia
Exploring the intersection of blockchain, AI, and African capital markets.

- GitHub: [@shux187](https://github.com/shux187)

---

## Acknowledgments

- **Patrick Collins** and the Cyfrin team for the foundational RWA tutorial
- **Chainlink Labs** for the oracle infrastructure powering this project
- **Foundry** and **OpenZeppelin** for the developer tooling