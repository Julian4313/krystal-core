项目是 krystal的 核心合约

注意：危险  setApprovalForAll(address operator,bool approved)
Uniswap的 ERC721Permit_v4的能力，owner 将 Uniswap LP token (NFT)的完全处理权限 给了   krystal 调仓合约。
说明：这个代码是 前端发起的，直接调用 协议合约，因此你这两里看不到代码

明：不同链，Ksystal分别部署了不同的合约，但是核心代码原理是一样的。
用户流程
合约逻辑
费用说明
用户： 创建仓位
[图片]
https://github.com/KrystalDeFi/v3utils/blob/3dcbdfe82f0b60341cfe7a1354167808afab49e3/src/V3Utils.sol#L436
swapAndMint
https://basescan.org/tx/0x0276d6d91f8de36795cca7a511085502d8d743932917721474bcf4cdac412bb8

第一步 ：扣除费用  
protocolFeeX64（liquidity fee）

扣除的是 

第二步 ：swap 
- Q: 使用哪个 DEX?
- A:  就使用当前的 Pool 所在的 Protocol
第三步：mint
- 调用对应协议，添加流动性, 并将 lp-nft 发给owner
第四步：剩余token 发给 owner 
 

费用参数：是按比例扣除
参数包含在用户签名内 —— 它这个类似 uniswap收取的前端交互费用

Zap
Dynamic: 0.05% | 0.1% | 0.25%
Based on pool fee tier:
• ≤ 0.05% → 0.05%
• 0.05–0.3% → 0.1%
• > 0.3% → 0.25% of zap amount

用户： 新增流动性  到已有仓位
[图片]
https://github.com/KrystalDeFi/v3utils/blob/3dcbdfe82f0b60341cfe7a1354167808afab49e3/src/V3Utils.sol#L538
swapAndIncreaseLiquidity
第一步 ：扣除费用  
protocolFeeX64（liquidity fee）
第二步 ：swap 
- Q: 使用哪个 DEX? 
- A:  就使用当前的 Pool 所在的 Protocol
第三步：mint 
- 添加流动性, 并将 lp-nft 发给owner
第四步：剩余token 发给 owner 


费用参数：是按比例扣除

参数包含在用户签名内 —— 它这个类似 uniswap收取的前端交互费用

Zap
Dynamic: 0.05% | 0.1% | 0.25%
Based on pool fee tier:
• ≤ 0.05% → 0.05%
• 0.05–0.3% → 0.1%
• > 0.3% → 0.25% of zap amount

用户： 手动rebalance  
[图片]

说明，这里没有调用Krystal合约，而是
直接组装calldata，调用 DEX的合约NonfungiblePositionManager的safeTransferFrom(x，calldata)

Calldata 黑箱，未知
管理员  ： 调仓
onlyRole(OPERATOR_ROLE)
https://github.com/KrystalDeFi/v3utils/blob/3dcbdfe82f0b60341cfe7a1354167808afab49e3/src/V3Automation.sol#L429
https://basescan.org/address/0x50c7954dAC02392FE3b4c6Df96BfF67d4Bc5b42C#code
[图片]

execute（调仓参数， order签名）
第一步 验证 order （没有被取消）
——它并没有验证 order里面的内容 与调仓参数是否有匹配，例如 gasfee）

第二步
- Transfer owner nft(lp token) 到该合约
- 移除当前仓位 所有流动性

第三步  扣除费用
对币对 A-B  扣除费用。
- Gas fee
- Liquidity fee 
- Performance fee 

第四步 swap  && mint
- 添加流动性, 并将 lp-nft 发给owner
第五步：剩余token 发给 owner 


扣费方式
- Gas fee  —— 虽然 用户在order里配置了，但这没有做校验
       扣费= A* 比例_1+ B *比例_1
- Liquidity fee 
       扣费= A* 比例_2+ B *比例_2
- Performance fee 
  - 如果本次compoundFees， 则会扣除performance fee
       扣费= A_LPfee* 比例_3 + B _LPfee*比例_3
  目前应该：2% of the generated LP fees,

扣费中心化
- 管理员可以任意调节费用——中心化

比例上限
初始值，可以修改
_maxFeeX64[FeeType.GAS_FEE] = 5534023222112865280; // 30%
_maxFeeX64[FeeType.LIQUIDITY_FEE] = 5534023222112865280; // 30%
 _maxFeeX64[FeeType.PERFORMANCE_FEE] = 5902958103587057000; // 32% = 30% gas for auto compound + 2% protocol fee

收款人
FEE_TAKER 
https://basescan.org/address/0x8C4f68B691BDc29deCe2c4e569a6Cff3f042676f#asset-multichain

用户移除流动性
[图片]
[图片]

[图片]

safeTransferFrom
它本质上是触发了 onERC721Received 函数
第一步   解析 instruction
第二步  移除流动性
decreaseLiquidityAndCollectFees
第三步  扣除费用
- instructions.liquidityFeeX64,
- instructions.performanceFeeX64
第四步 返还剩余资金

说明：扣费比例1和2，是前端组装到用户的instruction 里的
l
iquidityFeeX64： 指的是A /B token(扣除lp fee之后)* 扣费比例_1
performanceFeeX64： 指的是 lp fee * 扣费比例_2





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
