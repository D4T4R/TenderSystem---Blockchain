module.exports = {
  networks: {
    development: {
      host: "127.0.0.1",
      port: 8545, 
      network_id: "*"
    },
    rpc: {
      host: "localhost",
      gas: 5000000,
      port: 8545
    }},
  compilers: {
    solc: {
       version: "0.8.16",    // Fetch exact version from solc-bin (default: truffle's version)
      // docker: true,        // Use "0.5.1" you've installed locally with docker (default: false)
      // settings: {          // See the solidity docs for advice about optimization and evmVersion
      //  optimizer: {
      //    enabled: false,
      //    runs: 200
      //  },
      //  evmVersion: "byzantium"
      // }
    }
  }
};
