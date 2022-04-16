// SPDX-License-Identifier: UNLICENCED

pragma solidity ^0.8.1;

//importing some openzeppelin contracts 
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";

// inherit the contract that was imported and have access to the contract's methods
// calls the contract from the inhereted open zeppelin import
contract myEpicNFT  is ERC721URIStorage {
    // token counter from openzeppelin to keep track of NFT / tokenIDs
    
    // token counter from openzeppelin to keep track of NFT / tokenIds
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    // passing the name of the NFTs token and symbol
    constructor() ERC721 ("JujutsuNFT", "JUJUTSUKAISEN") {
        console.log("This is my first NFT contract. Cool, cool, cool.");
    }

    // function user will hit to receive their NFT
    function makeAnEpicNFT() public {
        // get the current tokenID, starting at 0
        uint256 newItemId = _tokenIds.current();

        // mint the NFT to the sender
        // tokenIds is a STATE VARIABLE. changes and stored directly in the contract
        // "mint nft with id newitemid to user with address msg.sender"
        // msg.sender is a variable solidity provides that gives us access to public address of person calling the contract
        // secure way to get users public address - can't "fake it", can't call anonymously
        _safeMint(msg.sender, newItemId);

        // set the NFTs data
        // set the nft unique id and data associated with that id
        // setting the actual data that maeks the nft valuable - attributes?
        _setTokenURI(newItemId, "https://jsonkeeper.com/b/YGUV");
        console.log("NFT with ID %s was minted for %s!", newItemId, msg.sender);

        // increment the token counter for the next minted NFT
        // increment is from open zeppelin
        _tokenIds.increment();
    }
}
