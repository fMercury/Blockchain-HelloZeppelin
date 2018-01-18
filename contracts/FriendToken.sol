pragma solidity ^0.4.13;

import 'zeppelin-solidity/contracts/token/MintableToken.sol';

contract FriendToken is MintableToken {
  string public name = "FRIEND TOKEN";
  string public symbol = "FRIEND";
  uint8 public decimals = 15;
}
