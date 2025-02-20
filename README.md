# AstroSeed: Decentralized Crowdfunding for Space Exploration

AstroSeed is a decentralized crowdfunding platform built on the Stacks blockchain that enables the funding of space exploration and innovation projects through transparent, community-governed processes.

## Table of Contents
- [Overview](#overview)
- [Features](#features)
- [Smart Contract Architecture](#smart-contract-architecture)
- [How It Works](#how-it-works)
- [Installation and Deployment](#installation-and-deployment)
- [Usage Guide](#usage-guide)
- [Configuration Parameters](#configuration-parameters)
- [Error Codes](#error-codes)
- [Security Considerations](#security-considerations)
- [Contributing](#contributing)
- [License](#license)
- [Contact](#contact)

## Overview

AstroSeed revolutionizes space project funding by creating a decentralized platform where visionaries can propose space exploration initiatives and receive STX token funding from a global community of backers. The platform incorporates governance mechanisms through voting to ensure accountability and project quality.

## Features

- **Decentralized Funding**: Projects receive STX tokens directly from backers without intermediaries
- **Community Governance**: Backers participate in project governance through voting
- **Transparent Fund Management**: Smart contract manages all funds with full transparency
- **Flexible Timeline**: Projects can extend deadlines based on funding progress
- **Founder Accountability**: Voting periods ensure founder accountability before funds release
- **Backer Protection**: Automatic refund mechanisms if projects fail to meet criteria

## Smart Contract Architecture

AstroSeed is built on a Clarity smart contract with the following key data structures:

### Data Maps
- `space-projects`: Stores all project details and funding status
- `project-backers`: Tracks contributions from individual backers
- `project-votes`: Records votes from project backers

### Key Functions
- `launch-project`: Creates a new space exploration funding campaign
- `back-project`: Allows users to fund a project with STX tokens
- `cast-vote`: Enables project backers to vote on project progress
- `claim-funds`: Allows founders to withdraw funds after meeting requirements
- `request-refund`: Enables backers to recover funds from failed projects
- `abort-project`: Allows founders to cancel projects before receiving funding
- `extend-project-deadline`: Permits deadline extensions under specific conditions

## How It Works

### Project Lifecycle

1. **Project Launch**
   - Founder defines project title, funding target, and end date
   - Smart contract creates project record with unique ID

2. **Funding Period**
   - Backers contribute STX tokens to projects they support
   - Contributions are held in escrow by the smart contract
   - Progress toward funding target is tracked transparently

3. **Voting Period**
   - After funding deadline, a voting period begins
   - Backers vote to approve or reject project progress
   - Voting period lasts for 7 days (configurable)

4. **Fund Release / Refund**
   - If funding target met AND positive vote threshold reached → founder can claim funds
   - If funding target NOT met OR vote threshold NOT reached → backers can claim refunds

### Deadline Extensions

Projects that have reached at least 75% of their funding target can request up to three deadline extensions (maximum 30 days each). This flexibility helps promising projects that need additional time to reach their goals.

## Installation and Deployment

### Prerequisites
- [Clarinet](https://github.com/hirosystems/clarinet) installed for local development
- [Stacks Wallet](https://www.hiro.so/wallet) for contract interaction
- Basic knowledge of Clarity and Stacks blockchain

### Local Development
```bash
# Clone the repository
git clone https://github.com/ibevivian/AstroSeed.git
cd astroseed

# Initialize Clarinet project (if starting from scratch)
clarinet new

# Test the contract
clarinet test
```

### Deployment
```bash
# Deploy to testnet
clarinet deploy --testnet

# Deploy to mainnet (requires proper key management)
clarinet deploy --mainnet
```

## Usage Guide

### For Project Founders

#### Launching a Project
```clarity
(contract-call? .astroseed launch-project "Mars Habitat Prototype" u1000000000 u79000)
```
Parameters:
- Project title (max 50 ASCII characters)
- Funding target (in microSTX)
- End date (in block height)

#### Extending a Deadline
```clarity
(contract-call? .astroseed extend-project-deadline u1 u83000)
```
Parameters:
- Project ID
- New end date (in block height)

#### Claiming Funds
```clarity
(contract-call? .astroseed claim-funds u1)
```
Parameters:
- Project ID

### For Backers

#### Contributing to a Project
```clarity
(contract-call? .astroseed back-project u1 u50000000)
```
Parameters:
- Project ID
- Contribution amount (in microSTX)

#### Voting on a Project
```clarity
(contract-call? .astroseed cast-vote u1 true)
```
Parameters:
- Project ID
- Approval (true/false)

#### Requesting a Refund
```clarity
(contract-call? .astroseed request-refund u1)
```
Parameters:
- Project ID

### Read-Only Functions

#### Get Project Details
```clarity
(contract-call? .astroseed get-space-project u1)
```

#### Check Contribution
```clarity
(contract-call? .astroseed get-backer-contribution u1 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM)
```

#### Check Voting Status
```clarity
(contract-call? .astroseed get-project-vote-status u1)
```

## Configuration Parameters

AstroSeed includes several configurable parameters that can be adjusted based on governance decisions:

| Parameter | Default Value | Description |
|-----------|---------------|-------------|
| `FUNDING_THRESHOLD` | 75% | Minimum funding percentage required for deadline extension |
| `MAX_EXTENSION_LENGTH` | 30 days | Maximum length of a single deadline extension |
| `VOTING_DURATION` | 7 days | Length of voting period after funding deadline |
| `MIN_APPROVAL_PERCENTAGE` | 60% | Minimum percentage of positive votes required |
| `MIN_REQUIRED_VOTES` | 10 | Minimum number of votes required for validity |

## Error Codes

| Error Code | Description |
|------------|-------------|
| u100 | Not authorized to perform this action |
| u101 | Project not found |
| u102 | Project already exists |
| u103 | Insufficient funds for operation |
| u104 | Deadline has passed |
| u105 | Funding target not met |
| u106 | Invalid input parameters |
| u107 | Project has existing backers |
| u108 | No more extensions available |
| u109 | Voting period still active |
| u110 | Vote requirements not met |

## Security Considerations

- **Escrow Security**: All funds are held by the contract until explicit release conditions are met
- **Deadline Integrity**: Block height is used for deadlines to prevent manipulation
- **Vote Manipulation Prevention**: Each backer can only vote once per project
- **Refund Guarantees**: Smart contract ensures backers can recover funds from failed projects

## Contributing

We welcome contributions to the AstroSeed platform! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

Please ensure all tests pass before submitting pull requests.

---

Built with ❤️ for the future of space exploration.