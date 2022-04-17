// SPDX-License-Identifier: UNLICENCED

pragma solidity ^0.8.1;

//importing some openzeppelin contracts 
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";

// importing helper functions via the added Base64.sol
import { Base64 } from "./libraries/Base64.sol";

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

    event NewEpicNFTMinted(address sender, uint256 tokenId);

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
        string memory combinedWord = string(abi.encodePacked(first, second, third));

        // concatenate all strings and close the text / svg tags
        string memory finalSvg = string(abi.encodePacked(baseSvg, first, second, third, "</text></svg>"));
       
       // get all of the JSON metadeta in place and base64 encode it
       string memory json = Base64.encode(
           bytes(
               string(
                   abi.encodePacked(
                       '{"name": "',
                       // set the title of the NFT as the generated word
                       combinedWord,
                       '", "description": "A highly acclaimed collection of DBZ squares.", "image": "data:image/svg+xml;base64,',
                       // we add data:image/svg+xml;base64 and append our base64 encode svg}
                       Base64.encode(bytes(finalSvg)),
                       '"}'
                   )
               )
           )
       );

       // prepend data:application/json;base64, to our data
       string memory finalTokenUri = string(
           abi.encodePacked("data:application/json;base64,", json)
       );

        console.log("\n----------------");
        console.log(finalTokenUri);
        console.log("----------------/n");

        // mint the NFT to the sender
        // tokenIds is a STATE VARIABLE. changes and stored directly in the contract
        // "mint nft with id newitemid to user with address msg.sender"
        // msg.sender is a variable solidity provides that gives us access to public address of person calling the contract
        // secure way to get users public address - can't "fake it", can't call anonymously
        _safeMint(msg.sender, newItemId);

        // update URI
    
        // set the NFTs data / updates URI
        // set the nft unique id and data associated with that id
        // setting the actual data that maeks the nft valuable - attributes?
        _setTokenURI(newItemId, finalTokenUri);
    
        // increment the token counter for the next minted NFT
        // increment is from open zeppelin
        _tokenIds.increment();
         console.log("NFT with ID %s was minted for %s!", newItemId, msg.sender);

        emit NewEpicNFTMinted(msg.sender, newItemId);
    }
}
