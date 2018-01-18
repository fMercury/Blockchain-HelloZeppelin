var FriendTokenPresale = artifacts.require("./FriendTokenPresale.sol");

it("Should log presale constructor data", async function() {

  const weiRaised = web3.toWei(3333, 'ether');
  const maxCap = web3.toWei(25000, 'ether');
  const wallet = '0xDAD697274F95F909ad12437C516626d65263Ce47';

  const constructorData = await web3.eth.contract(FriendTokenPresale.abi)
    .new.getData(weiRaised, maxCap, wallet,
      {data: FriendTokenPresale.unlinked_binary}
    );

  console.log('Bytecode for deploy:', constructorData);
  console.log('Constructor params encoded:',
    constructorData.replace(FriendTokenPresale.unlinked_binary, ''));

  let presale = await FriendTokenPresale.new(
    weiRaised, maxCap, wallet
  );

});
