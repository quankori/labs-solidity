# Smart contract Game Wheel

## Setup

1. Copy .env.example to .env
2. Edit .env file
3. Run command

```
yarn install
```

## Deploy Testnet

```
yarn deploy
```

## Run test

```
yarn test
```

## Info Testnet

Token

```
https://testnet.bscscan.com/address/0x48F36e01f243cFa6d3E2525f8E05944c68441fC6
```

Claim

```
https://testnet.bscscan.com/address/0xefaD4d2AA82984E1cb53dBC8dA55A1C1990339aC
```

Wheel

```
https://testnet.bscscan.com/address/0xF068E22849A83c376e1EaCf85616029Ec607aC69
```

## How to play

### In user case

1. Claim Token

Access `claim contract` [link](https://testnet.bscscan.com/address/0xefaD4d2AA82984E1cb53dBC8dA55A1C1990339aC#writeContract) to get free token

2. Approve token

Access `token contract` [link](https://testnet.bscscan.com/address/0xefaD4d2AA82984E1cb53dBC8dA55A1C1990339aC#writeContract) to function approve token for game with function `approve(0xF068E22849A83c376e1EaCf85616029Ec607aC69, 1000000000000000000)`

3. Play game

Access `wheel contract` [link](https://testnet.bscscan.com/address/0xF068E22849A83c376e1EaCf85616029Ec607aC69#writeContract) to play game token for game with function `betWheel(your_number)`. Will throw error if admin don't create play game

### In admin case (connect me to get private key for game)

1. Create game

Access `wheel contract` [link](https://testnet.bscscan.com/address/0xF068E22849A83c376e1EaCf85616029Ec607aC69#writeContract) to create game with function `createWheel`. Will throw error if wallet is not admin

2. Stop game

Access `wheel contract` [link](https://testnet.bscscan.com/address/0xF068E22849A83c376e1EaCf85616029Ec607aC69#writeContract) to stop game with function `stopWheel`. Will throw error if wallet is not admin

3. Get history result

Access `wheel contract` [link](https://testnet.bscscan.com/address/0xF068E22849A83c376e1EaCf85616029Ec607aC69#readContract) to function `resultWheel(number_of_match)` to get result in room
