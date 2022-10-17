for (let i = 0; i < eth.accounts.length; i++) {
    personal.unlockAccount(eth.accounts[i], "123", 0);
}

miner.setEtherbase(eth.accounts[14]);
miner.start();