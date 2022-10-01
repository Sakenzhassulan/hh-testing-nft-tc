// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "base64-sol/base64.sol";

contract MyEmojiNFT is ERC721URIStorage {
    uint256 public s_tokenCounter;
    string private constant base64EncodedSvgPrefix = "data:image/svg+xml;base64,";

    event CreatedNFT(uint256 indexed tokenId, string tokenURI);

    constructor() ERC721("My Emoji NFT", "MNFT") {
        s_tokenCounter = 0;
    }

    function mintNFT(string memory svg) public {
        _safeMint(msg.sender, s_tokenCounter);
        string memory imageURI = svgToImageURI(svg);
        string memory tokenURI = formatTokenURI(imageURI);
        _setTokenURI(s_tokenCounter, tokenURI);
        s_tokenCounter = s_tokenCounter + 1;
        emit CreatedNFT(s_tokenCounter, tokenURI);
    }

    function svgToImageURI(string memory _svg) public pure returns (string memory) {
        string memory svgBase64Encoded = Base64.encode(bytes(string(abi.encodePacked(_svg))));
        string memory imageURI = string(abi.encodePacked(base64EncodedSvgPrefix, svgBase64Encoded));
        return imageURI;
    }

    function formatTokenURI(string memory _imageURI) public pure returns (string memory) {
        string memory baseURI = "data:application/json;base64,";
        return
            string(
                abi.encodePacked(
                    baseURI,
                    Base64.encode(
                        bytes(
                            abi.encodePacked(
                                '{"name":"',
                                "SVG NFT",
                                '", "description":"An NFT that changes based on the Chainlink Feed", ',
                                '"attributes": [{"trait_type": "coolness", "value": 100}], "image":"',
                                _imageURI,
                                '"}'
                            )
                        )
                    )
                )
            );
    }
}
