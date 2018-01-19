var BigNumber = web3.BigNumber;

require('chai')
  .use(require('chai-bignumber')(BigNumber))
  .should();

var Presale = artifacts.require("./Presale.sol");

contract('Presale', function(accounts) {

  it("Should create a Presale", async function() {

    const initialWalletBalance = await web3.eth.getBalance(accounts[1]);
    const wallet = accounts[1];

    let weiRaised = new BigNumber(0);
    const maxCap = web3.toWei(20, 'ether');
    const startTimestamp = web3.eth.getBlock(web3.eth.blockNumber).timestamp + 10 // ten second in the future
    const endTimestamp = startTimestamp + (86400 * 20) // 20 days
    const rate = new web3.BigNumber(24000) // presale rate is 20% up

    let presale = await Presale.new(wallet, weiRaised, maxCap, startTimestamp, endTimestamp, rate);

    weiRaised.should.be.bignumber.equal(await presale.weiRaised());
    assert.equal(maxCap, await presale.maxCap());
    assert.equal(wallet, await presale.wallet());
    assert.equal(true, await presale.paused());

    // Unpause the presale
    await presale.unpause({from: accounts[0]});
    assert.equal(false, await presale.paused());

    // Send some ether ans test the forwarding to the wallet address
    await web3.eth.sendTransaction({
      to: presale.address,
      value: web3.toWei(10, 'ether'),
      from: accounts[2]
    });

    weiRaised = weiRaised.plus(web3.toWei(10, 'ether'));

    weiRaised.should.be.bignumber.equal(await presale.weiRaised());
    initialWalletBalance.plus(weiRaised)
      .should.be.bignumber.equal(await web3.eth.getBalance(accounts[1]));

    // Pause the presale and dont allow to receive ether
    await presale.pause({from: accounts[0]});

    try {
      await web3.eth.sendTransaction({
        to: presale.address,
        value: web3.toWei(10, 'ether'),
        from: accounts[2]
      });
    } catch (e) {
      if (e.message.search('invalid opcode') == 0) throw e;
    }

    weiRaised.should.be.bignumber.equal(await presale.weiRaised());
    initialWalletBalance.plus(weiRaised)
      .should.be.bignumber.equal(await web3.eth.getBalance(accounts[1]));

    // Dont allow to receive more than max cap
    try {
      await web3.eth.sendTransaction({
        to: presale.address,
        value: web3.toWei(12, 'ether')+1,
        from: accounts[2]
      });
    } catch (e) {
      if (e.message.search('invalid opcode') == 0) throw e;
    }

    weiRaised.should.be.bignumber.equal(await presale.weiRaised());
    initialWalletBalance.plus(weiRaised)
      .should.be.bignumber.equal(await web3.eth.getBalance(accounts[1]));

    // Unpause it and finish
    await presale.unpause({from: accounts[0]});

    await web3.eth.sendTransaction({
      to: presale.address,
      value: web3.toWei(10, 'ether'),
      from: accounts[2]
    });

    weiRaised = weiRaised.plus(web3.toWei(10, 'ether'));

    weiRaised.should.be.bignumber.equal(await presale.weiRaised());
    initialWalletBalance.plus(weiRaised)
      .should.be.bignumber.equal(await web3.eth.getBalance(accounts[1]));

    // Dont allow to receive more than max cap once is it reached
    try {
      await web3.eth.sendTransaction({
        to: presale.address,
        value: 1,
        from: accounts[2]
      });
    } catch (e) {
      if (e.message.search('invalid opcode') == 0) throw e;
    }

    weiRaised.should.be.bignumber.equal(await presale.weiRaised());
    initialWalletBalance.plus(weiRaised)
      .should.be.bignumber.equal(await web3.eth.getBalance(accounts[1]));
  });

});
