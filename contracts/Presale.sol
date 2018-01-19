pragma solidity ^0.4.15;

import "zeppelin-solidity/contracts/ownership/Ownable.sol";
import "zeppelin-solidity/contracts/lifecycle/Pausable.sol";
import "zeppelin-solidity/contracts/math/SafeMath.sol";

/**
 * @title Presale
 * @dev Contract to raise a max amount of Ether before ICO/TGE
 *
 * The token rate is XX Tokens generate per Ether, if you send 10 Ethers you
 * will receive XX x10 Tokens after TGE ends
 * The contract is pausable and it starts in paused state
  */

contract Presale is Ownable, Pausable {
  using SafeMath for uint256;

  // The address where all funds will be forwarded
  address public wallet;

  // The total amount of wei raised
  uint256 public weiRaised;

  // The maximun amount of wei to be raised
  uint256 public maxCap;

  /**
   @dev Constructor. Creates the Presale contract
   The contract can start with some wei already raised, it will
   also have a maximun amount of wei to be raised and a wallet
   address where all funds will be forwarded inmediatly.

   @param _weiRaised see `weiRaised`
   @param _maxCap see `maxCap`
   @param _wallet see `wallet`
   */

  function Presale(uint256 _weiRaised, uint256 _maxCap, address _wallet) public {
   require(_weiRaised < _maxCap);

   weiRaised = _weiRaised;
   maxCap = _maxCap;
   wallet = _wallet;
   paused = true;
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

  /**
   @dev Allows to add the address and the amount of wei sent by a contributor
   in the private presale. Can only be called by the owner.

   @param beneficiary Address to which Lif will be sent
   @param weiSent Amount of wei contributed
   @param rate Lif per ether rate at the moment of the contribution
   */

  // The_senders address and the wei_amount_sent

  mapping(address => uint256 ) public senders;

  function addSender( address addressSender, uint256 weiSent) public
  onlyOwner {
    require(weiSent > 0);
    senders[addressSender] = weiSent;

    }
}
