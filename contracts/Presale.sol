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
