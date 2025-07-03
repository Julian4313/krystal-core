项目是 krystal的 核心合约

注意：危险  setApprovalForAll(address operator,bool approved)
Uniswap的 ERC721Permit_v4的能力，owner 将 Uniswap LP token (NFT)的完全处理权限 给了   krystal 调仓合约。
说明：这个代码是 前端发起的，直接调用 协议合约，因此你这两里看不到代码


# Introduction

[![built-with openzeppelin](https://img.shields.io/badge/built%20with-OpenZeppelin-3677FF)](https://docs.openzeppelin.com/)

Smart Contracts for Krystal to help interact with protocols on Binance Smart Chain;

## Package Manager

We use `yarn` as the package manager. You may use `npm` and `npx` instead, but commands in bash scripts may have to be changed accordingly.

## Setup

1. Clone this repo
2. `yarn install`

## Compilation

`yarn compile` to compile contracts for all solidity versions.

## Setting

Create `.env` and `.env.<chain>.<network>` following the samples in this repo.

`.env` includes some common configs, such as `PRIVATE_KEY` and the common `INFURA_API_KEY`.
Meanwhile, the `.env.<chain>.<network>` is the config the particular chain - network .i.e `ETHERSCAN_KEY`, `MULTISIG`, etc.

> `.env.sample`
```
PRIVATE_KEY=0x          // private key to interact with blockchain
INFURA_API_KEY=xxx
```

> `.env.eth.mainnet.sample`
```
ETHERSCAN_KEY=xxx
MAINNET_FORK=https://eth-mainnet.alchemyapi.io      // archive chain url, for testing
MAINNET_ID=1                                        // chain ID
MAINNET_FORK_BLOCK=12644714                         // start forking from this block for testing
MULTISIG=0x                                         // multisig address if have, only gnosis-safe[https://gnosis-safe.io/] is supported
```

## Testing

1. If contracts have not been compiled, run `yarn compile` or `yarn c`. This step can be skipped subsequently.
2. Run `yarn test -h` for instruction

```bash
yarn <deploy,test> [-h] [-c <eth,bsc,polygon>] [-n <mainnet,testnet,ropsten>] -- to run test on specific chain and network

where:
    -h  show this help text
    -c  which chain to run, supported <eth,bsc,polygon>
    -n  which network to run, supported <mainnet,testnet,ropsten,mumbai>
    -f  specific test to run if any
```

## Deploying

1. Run `yarn deploy -h` for instruction

```bash
yarn <deploy,test> [-h] [-c <eth,bsc,polygon>] [-n <mainnet,testnet,ropsten>] -- to run test on specific chain and network

where:
    -h  show this help text
    -c  which chain to run, supported <eth,bsc,polygon>
    -n  which network to run, supported <mainnet,testnet,ropsten,mumbai>
    -f  specific test to run if any
```

### Example Commands

- `yarn test` (Runs all tests)
- `yarn test -f ./test/swap.test.ts` (Test only swap.test.ts)

## Coverage

- Run `yarn coverage` for coverage on files
