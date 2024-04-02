### Project title
Assets cross chain bridge

### Team members
    ziheche

### Project Overview
Depolyed a bridge between Optimism and Base, user can transfer their assets by using this bridge

### Run-book
1. Install dependencies， compile code, deploy contract
```shell
just install
npx hardhat compile
just deploy optimism base
```
2. Port address
    Optimism - Sepolia: 0x062aF4E4527565c6F486f7f5b080006397402f2d
    Base - Sepolia: 0x062aF4E4527565c6F486f7f5b080006397402f2d
3. Bridge method is `TransferCNY` params: `(address destPortAddr,
        bytes32 channelId,
        uint256 amount)`
4. frontend page
```
npm install && npm run start
```
### Assets
```
subway tray panda three indoor eyebrow grit sunset cannon trophy slush wealth
```

### Licence
[Apache 2.0](LICENSE)

