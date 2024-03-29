//SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.9;

import "./base/UniversalChanIbcApp.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract AssetsCrossChainBridge is UniversalChanIbcApp, ERC20 {
    constructor(
        address _middleware
    ) UniversalChanIbcApp(_middleware) ERC20("China yuan", "CNY") {
        _mint(
            msg.sender,
            10000000000 * 10 ** decimals()
        );
    }

    // 发送链调用这个函数
    function TransferCNY(
        address destPortAddr,
        bytes32 channelId,
        uint256 amount
    ) external {
        // 先判断发送链的余额是否足够
        require(balanceOf(msg.sender) >= amount, "Insufficient balance");
        bytes memory payload = abi.encode(msg.sender, amount);
        uint64 timeoutTimestamp = uint64(
            (block.timestamp + 36000) * 1000000000
        );

        IbcUniversalPacketSender(mw).sendUniversalPacket(
            channelId,
            IbcUtils.toBytes32(destPortAddr),
            payload,
            timeoutTimestamp
        );
    }

    // 发送链收到目标链的ack后，会调用这个函数
    function onUniversalAcknowledgement(
        bytes32 channelId,
        UniversalPacket memory packet,
        AckPacket calldata ack
    ) external override onlyIbcMw {
        ackPackets.push(UcAckWithChannel(channelId, packet, ack));

        (address account, uint256 amount) = abi.decode(
            packet.appData,
            (address, uint256)
        );
        // 确认目标链已经收到信息后，发送链进行burn操作
        _burn(account, amount);
    }

    // 目标链收到信息后，会调用这个函数
    function onRecvUniversalPacket(
        bytes32 channelId,
        UniversalPacket calldata packet
    ) external override onlyIbcMw returns (AckPacket memory ackPacket) {
        recvedPackets.push(UcPacketWithChannel(channelId, packet));
        (address account, uint256 amount) = abi.decode(
            packet.appData,
            (address, uint256)
        );
        // 目标链收到信息后，进行mint操作
        _mint(account, amount);
        return AckPacket(true, abi.encode(packet.appData));
    }

}
