//1//const FriendTokenCrowdsale = artifacts.require("./FriendTokenCrowdsale.sol")
const FriendTokenPresale = artifacts.require('./FriendTokenPresale.sol')

module.exports = function(deployer, network, accounts) {
  //1//const startTime = web3.eth.getBlock(web3.eth.blockNumber).timestamp + 1 // one second in the future
  //1//const endTime = startTime + (86400 * 20) // 20 days
  //1//const rate = new web3.BigNumber(1000)
  //1//const wallet = accounts[0]
  //1//deployer.deploy(FriendTokenCrowdsale, startTime, endTime, rate, wallet)

  const wallet = accounts[0]
  const weiRaised = 0
  const maxCap = 3333
  const startTimestamp = web3.eth.getBlock(web3.eth.blockNumber).timestamp + 10 // ten second in the future
  const endTimestamp = startTimestamp + (86400 * 20) // 20 days
  const rate = new web3.BigNumber(24000) // presale rate is 20% up

  deployer.deploy(FriendTokenPresale, wallet, weiRaised, maxCap, startTimestamp, endTimestamp, rate)
};
