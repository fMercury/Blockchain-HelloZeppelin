pragma solidity ^0.4.15;

import './FriendToken.sol';

/**
 * @title FriendToken-Presale
 * @dev Contract to raise a max amount of Ether before ICO/TGE
 *
 * The token rate is 20000 FriendToken per Ether, if you send 10 Ethers you will
 * receive 200000 Lifs after TGE ends
 * The contract is pausable and it starts in paused state
  */

contract FriendTokenPresale is Presale {

  function FriendTokenPresale(uint256 _weiRaised, uint256 _maxCap, address _wallet) public {
    Presale(weiRaised, maxCap, wallet)
  }

  /**
     @dev Fallback function that will be executed every time the contract
     receives ether, the contract will accept ethers when is not paused and
     when the amount sent plus the wei raised is not higher than the max cap.

     ONLY send from a ERC20 compatible wallet like myetherwallet.com
   */
  function () public whenNotPaused payable {
    require(weiRaised.add(msg.value) <= maxCap);

    weiRaised = weiRaised.add(msg.value);
    wallet.transfer(msg.value);
  }

}
