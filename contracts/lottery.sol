// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract Lottery{
    address manager;
    address payable [] public participants;

    constructor(){
        manager = msg.sender;   //global variable
    }

    receive() payable external{
        require(msg.value >= 1 ether);
        participants.push(payable(msg.sender));
    }

    function getBalance() public view returns(uint){
        require(msg.sender == manager);
        return address(this).balance;
    }

    function random() public view returns(uint){
        return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, participants.length)));
    }

    function selectWinner() public{
        require(msg.sender == manager);
        require(participants.length >= 3);
        uint r = random();
        uint i = r % participants.length;
        participants[i].transfer(getBalance());
        participants = new address payable[](0);
    }
}