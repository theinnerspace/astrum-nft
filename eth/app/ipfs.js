const { promisify } = require("util");
const fs = require("fs");
const readFile = promisify(fs.readFile);
const IPFS = require('ipfs-core');
const args = process.argv.slice(2);

async function readMetadata(f) {
    let metadata = "";
    try {
        metadata = (await readFile(f)).toString().trim();
    } catch (e) {
        if (e.code !== "ENOENT") {
            console.log(e)
        }
    }
    return metadata;
}

async function uploadFile(file) {
    data = await readMetadata(file);

    const ipfs = await IPFS.create()
    const { cid } = await ipfs.add(data, { pin: true })
    return cid.toString();
}

uploadFile(args[0]).then(result => {
    console.log(result)
}).catch(error => {
    console.log(error)
}).finally(() => {
    process.exit(0)
})