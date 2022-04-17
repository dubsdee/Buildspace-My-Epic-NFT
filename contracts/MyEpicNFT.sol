// SPDX-License-Identifier: UNLICENCED

pragma solidity ^0.8.1;

//importing some openzeppelin contracts 
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";

// importing helper functions via the added Base64.sol
import { Base64 } from "/.libraries/Base64.sol";

// inherit the contract that was imported and have access to the contract's methods
// calls the contract from the inhereted open zeppelin import
contract myEpicNFT  is ERC721URIStorage {
    // token counter from openzeppelin to keep track of NFT / tokenIds
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    // SVG code - need to change the word that is displayed, everything else stays the same
    // make a baseSvg variable here that all of our NFTs can use
    string baseSvg = "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'> <style>.base { fill: white; font-family: serif; font-size: 14px; }</style> <rect width='100%' height='100%' fill='black' /> <text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>";

    // create three arrays, each with their own theme of random words
    // pick some random words, names, etc
    string[] firstWords = ["Quick", "Hard", "Slow", "Smelly", "Awkward", "Tired", "Sneaky", "Loud"];
    string[] secondWords = ["Punching", "Kicking", "Fighting", "Sleeping", "Laughing", "Eating", "Flying"];
    string[] thirdWords = ["Goku", "Vegeta", "Goten", "Trunks", "Gohan", "Master Roshi", "Buu", "Cell", "Freeza"];
    // passing the name of the NFTs token and symbol
    constructor() ERC721 ("DragonBallNFT", "DragonBall") {
        console.log("This is my first NFT contract. Cool, cool, cool.");
    }


    // function to randomly pick word from each array
    function pickRandomFirstWord(uint256 tokenId) public view returns (string memory) {
        // seed random number generator
        // takes the string FW, takes the string version of the token ID, combines them and uses that as the random seed 
        uint256 rand = random(string(abi.encodePacked("FIRST_WORD", Strings.toString(tokenId))));
        // takes the combined new "rand" and modolos it by the length of the firstwords array, 
        // ensuring that the resulting value will have a corresponding element 
        rand = rand % firstWords.length;
        return firstWords[rand];
    }

    function pickRandomSecondWord(uint256 tokenId) public view returns (string memory) {
        uint256 rand = random(string(abi.encodePacked("SECOND_WORD", Strings.toString(tokenId))));
        rand = rand % secondWords.length;
        return secondWords[rand];
    }

    function pickRandomThirdWord(uint256 tokenId) public view returns (string memory) {
        uint256 rand = random(string(abi.encodePacked("THIRD_WORD", Strings.toString(tokenId))));
        rand = rand % thirdWords.length;
        return thirdWords[rand];
    }

    function random(string memory input) internal pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(input)));
    }

    // function user will hit to receive their NFT
    function makeAnEpicNFT() public {
        // get the current tokenID, starting at 0
        uint256 newItemId = _tokenIds.current();

        //randomly grab one word from each of the arrays
        string memory first = pickRandomFirstWord(newItemId);
        string memory second = pickRandomSecondWord(newItemId);
        string memory third = pickRandomThirdWord(newItemId);

        // concatenate all strings and close the text / svg tags
        string memory finalSvg = string(abi.encodePacked(baseSvg, first, second, third, "</text></svg>"));
        console.log("\n----------------");
        console.log(finalSvg);
        console.log("----------------/n");

        // mint the NFT to the sender
        // tokenIds is a STATE VARIABLE. changes and stored directly in the contract
        // "mint nft with id newitemid to user with address msg.sender"
        // msg.sender is a variable solidity provides that gives us access to public address of person calling the contract
        // secure way to get users public address - can't "fake it", can't call anonymously
        _safeMint(msg.sender, newItemId);

        // set the NFTs data
        // set the nft unique id and data associated with that id
        // setting the actual data that maeks the nft valuable - attributes?
        _setTokenURI(newItemId, "data:application/json;base64,ewogICAgIm5hbWUiOiAiRXBpY0xvcmRIYW1idXJnZXIiLAogICAgImRlc2NyaXB0aW9uIjogIkFuIE5GVCBmcm9tIHRoZSBoaWdobHkgYWNjbGFpbWVkIHNxdWFyZSBjb2xsZWN0aW9uIiwKICAgICJpbWFnZSI6ICJkYXRhOmltYWdlL3N2Zyt4bWw7YmFzZTY0LFBITjJaeUI0Yld4dWN6MGlhSFIwY0RvdkwzZDNkeTUzTXk1dmNtY3ZNakF3TUM5emRtY2lJSEJ5WlhObGNuWmxRWE53WldOMFVtRjBhVzg5SW5oTmFXNVpUV2x1SUcxbFpYUWlJSFpwWlhkQ2IzZzlJakFnTUNBek5UQWdNelV3SWo0S0lDQWdJRHh6ZEhsc1pUNHVZbUZ6WlNCN0lHWnBiR3c2SUhkb2FYUmxPeUJtYjI1MExXWmhiV2xzZVRvZ2MyVnlhV1k3SUdadmJuUXRjMmw2WlRvZ01UUndlRHNnZlR3dmMzUjViR1UrQ2lBZ0lDQThjbVZqZENCM2FXUjBhRDBpTVRBd0pTSWdhR1ZwWjJoMFBTSXhNREFsSWlCbWFXeHNQU0ppYkdGamF5SWdMejRLSUNBZ0lEeDBaWGgwSUhnOUlqVXdKU0lnZVQwaU5UQWxJaUJqYkdGemN6MGlZbUZ6WlNJZ1pHOXRhVzVoYm5RdFltRnpaV3hwYm1VOUltMXBaR1JzWlNJZ2RHVjRkQzFoYm1Ob2IzSTlJbTFwWkdSc1pTSStSWEJwWTB4dmNtUklZVzFpZFhKblpYSThMM1JsZUhRK0Nqd3ZjM1puUGc9PSIKfQ==");
    
        // increment the token counter for the next minted NFT
        // increment is from open zeppelin
        _tokenIds.increment();
         console.log("NFT with ID %s was minted for %s!", newItemId, msg.sender);
    }
}
