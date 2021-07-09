const Astrum = artifacts.require('Astrum')

const baseURI = 'https://ipfs.io/ipfs/QmUYWv6RaHHWkk5BMHJH4xKPEKNqAYKomeiTVobAMyxsbz/'

contract('Astrum', accounts => {

    it('should deploy correctly and be owned', () =>
        Astrum.deployed()
            .then(instance => instance.owner())
            .then(owner => assert.equal(owner, accounts[0]))
    )

    it('should have an initial supply of 110', () =>
        Astrum.deployed()
            .then(instance => instance.balanceOf(accounts[0]))
            .then(balance => assert.equal(balance, 110))
    )

    it('should return a default value for tokenURI', () =>
        Astrum.deployed()
            .then(instance => instance.tokenURI(1))
            .then(uri => assert.equal(uri, baseURI + 'M1.json'))
    )

    it('should check permissions on setBaseURI', async () => {

        let instance = await Astrum.deployed()
        try {
            await instance.setBaseURI('https://example.com/', { from: accounts[1] })
            assert.fail()
        } catch (e) {
            assert.include(e.message, 'is not the owner')
        }

        try {
            await instance.setBaseURI('https://example.com/', { from: accounts[0] })
            let tokenURI = await instance.tokenURI(1)
            assert.equal(tokenURI, 'https://example.com/M1.json')
        } catch (e) {
            assert.fail()
        }

    })

})
