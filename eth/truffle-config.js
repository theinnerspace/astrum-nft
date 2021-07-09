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
        },
        rinkeby: {
            provider: function() {
                return new HDWalletProvider('simple topple extend gold credit canal mesh tuna lawn envelope nephew minute', 'https://rinkeby.infura.io/v3/e895bb8854ab409cb2c25d7b3238bc6b')
            },
            network_id: 4,
            gas: 4500000,
            gasPrice: 10000000000
        }
    }
}
