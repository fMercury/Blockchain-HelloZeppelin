pragma solidity ^0.4.15;

import "zeppelin-solidity/contracts/ownership/Ownable.sol";
import "zeppelin-solidity/contracts/lifecycle/Pausable.sol";
import "zeppelin-solidity/contracts/math/SafeMath.sol";

/**
 * @title Presale
 * @dev Contract to raise a max amount of Ether before ICO/TGE
 * The token rate is XX Tokens generate per Ether, if you send 10 Ethers you will receive XX x10 Tokens after TGE ends The contract is pausable and it starts in paused state
 */

contract Presale is Ownable, Pausable {
  using SafeMath for uint256;

  // The address where all funds will be forwarded
  address public wallet;

  // The total amount of wei raised
  uint256 public weiRaised;

  // The maximun amount of wei to be raised
  uint256 public maxCap;

  // Beginning of the period where tokens can be purchased at `Presale` rate.
  uint256 public startTimestamp;

  // Marks the end of the Presale.
  uint256 public endTimestamp;

  // wei rate
  uint256 public rate;

  /**
  * @dev Constructor. Creates the Presale contract
  * The contract can start with some wei already raised, it will also have a maximun amount of wei to be raised and a wallet address where all funds will be forwarded inmediatly.
  * @param _wallet see `wallet`
  * @param _weiRaised see `weiRaised`
  * @param _maxCap see `maxCap`
  * @param _startTimestamp see `startTimestamp`
  * @param _endTimestamp see `endTimestamp`
  * @param _rate see `rate`
  */

  function Presale(address _wallet, uint256 _weiRaised, uint256 _maxCap, uint256 _startTimestamp, uint256 _endTimestamp, uint256 _rate) public {
    require(_weiRaised < _maxCap);
    require(_startTimestamp > block.timestamp);
    require(_startTimestamp < _endTimestamp);
    require(_rate > 0 );

    wallet = _wallet;
    weiRaised = _weiRaised;
    maxCap = _maxCap;
    startTimestamp = _startTimestamp;
    endTimestamp = _endTimestamp;
    rate = _rate;
    paused = true;
    }

  /**
  * @dev Fallback function that will be executed every time the contract receives ether, the contract will accept ethers when is not paused, when the amount sent plus the wei raised is not higher than the max cap and before the endTimestamp. ONLY send from a ERC20 compatible wallet like myetherwallet.com
  */
  function () public whenNotPaused payable {
    require(block.timestamp < endTimestamp);
    require(msg.value > 0);
    require(weiRaised.add(msg.value) <= maxCap);

    wallet.transfer(msg.value);
    weiRaised = weiRaised.add(msg.value);

    addSender(msg.sender, msg.value);
    }

  /**
   * @dev Allows to add the address and the amount of wei sent by a contributor in the private presale. Can only be called by the owner.

   * @param senders Address to which XToken will be sent
   * @param weiSent Amount of wei contributed
   */

  // The_senders address and the wei_amount_sent
  mapping(address => uint256 ) public senders;

  function addSender( address addressSender, uint256 weiSent) public onlyOwner {
    senders[addressSender] = weiSent;

    TokenPresalePurchase( addressSender, weiSent, rate);
    }

  /**
  * @dev Event triggered every time a presale purchase is done
  */
  event TokenPresalePurchase(address sender, uint256 weiAmount, uint256 rate);

}
