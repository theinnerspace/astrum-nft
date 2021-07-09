const fs = require('fs');
const Web3 = require('web3');
const ethers = require('ethers');


let mnemonic = "simple topple extend gold credit canal mesh tuna lawn envelope nephew minute";
let mnemonicWallet = ethers.Wallet.fromMnemonic(mnemonic);
const privateKey = mnemonicWallet.privateKey;
console.log(privateKey)

const rpcURL = "https://rinkeby.infura.io/v3/e895bb8854ab409cb2c25d7b3238bc6b"
const web3 = new Web3(rpcURL)
const address = "0x9203c01850Cb860641fC4C4BA98fB971F24F5137"
let account = web3.eth.accounts.privateKeyToAccount(privateKey);

const data = fs.readFileSync('../build/contracts/Astrum.json', 'utf8');
const abi = JSON.parse(data).abi;
const contract = new web3.eth.Contract(abi, address)
contract.methods.createAstrum("diocane").call(
    from = account,
    (err, result) => { console.log(err) })