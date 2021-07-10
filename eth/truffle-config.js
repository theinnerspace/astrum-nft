// Allows us to use ES6 in our migrations and tests.
require('babel-register')
require('babel-polyfill')
const HDWalletProvider = require("truffle-hdwallet-provider");

module.exports = {
    compilers: {
        solc: {
            version: '0.8.0'
        }
    },
    networks: {
        development: {
            host: '127.0.0.1',
            port: 8545,
            network_id: '*' // Match any network id
        }
    }
}
