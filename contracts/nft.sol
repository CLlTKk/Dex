// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
 
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MyNFT is ERC1155URIStorage, Ownable{
    constructor() ERC1155("https://ipfs.io/ipfs/QmWtYuyLhpa4NsyRz3HNHnMwzWdGggukC351C6yWnURTea/") Ownable(msg.sender){

    }

    function mint(address to, uint id, uint value) external onlyOwner{
        _mint(to, id, value, "0x0");
        _setURI(id, uri(id));
    }

    function setBaseURI(string memory newURI) external onlyOwner{
        _setBaseURI(newURI);
    }
}