//1//const FriendTokenCrowdsale = artifacts.require("./FriendTokenCrowdsale.sol")
const FriendTokenPresale = artifacts.require('./FriendTokenPresale.sol')

module.exports = function(deployer, network, accounts) {
  //1//const startTime = web3.eth.getBlock(web3.eth.blockNumber).timestamp + 1 // one second in the future
  //1//const endTime = startTime + (86400 * 20) // 20 days
  //1//const rate = new web3.BigNumber(1000)
  //1//const wallet = accounts[0]
  //1//deployer.deploy(FriendTokenCrowdsale, startTime, endTime, rate, wallet)

  const weiRaised = 0
  const maxCap = 3333
  const wallet = accounts[0]
  const rate = new web3.BigNumber(24000)
  deployer.deploy(FriendTokenPresale, weiRaised, maxCap, wallet, rate)
};
