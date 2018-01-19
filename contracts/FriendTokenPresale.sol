pragma solidity ^0.4.15;

import './FriendToken.sol';
import './Presale.sol';

/**
 * @title FriendTokenPresale
 * @dev Contract to raise a max amount of Ether before ICO/TGE
 *
 * The token rate is 20000 FriendToken per Ether, if you send 10 Ethers you will
 * receive 200000 Lifs after TGE ends, but in the presale the rate is for this
 * reason the rate in this stage is saved.
 * The contract is pausable and it starts in paused state
  */

contract FriendTokenPresale is Presale {

  function FriendTokenPresale(address _wallet, uint256 _weiRaised, uint256 _maxCap, uint256 _startTimestamp, uint256 _endTimestamp, uint256 _rate) public {
    }

}
