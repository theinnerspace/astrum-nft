// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract Astrum is ERC721, Ownable {

    using Strings for uint256;
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIds;

    string public baseURI;

    constructor () ERC721 ("Astrum", "ASTRUM") {

        baseURI = "https://ipfs.io/ipfs/QmUYWv6RaHHWkk5BMHJH4xKPEKNqAYKomeiTVobAMyxsbz/";

        for (uint i = 1; i <= 110; i++) {
            _tokenIds.increment();
            _mint(msg.sender, _tokenIds.current());
        }

    }

    function setBaseURI(string memory uri) external onlyOwner {
        baseURI = uri;
    }

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        require(_exists(tokenId), "URI query for nonexistent token");
        return string(abi.encodePacked(baseURI, "M", tokenId.toString(), ".json"));
    }

}
