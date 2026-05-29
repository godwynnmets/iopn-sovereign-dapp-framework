// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

/**
 * @title MosaicFactory
 * @author Genesis n-Badge Holder 0x317074C86d87c378df1E4264FD855c13AA6192a0
 * @notice Sovereign RWA Tokenization Factory for IOPn OPN Chain
 */
contract MosaicFactory is Initializable, UUPSUpgradeable, AccessControlUpgradeable {
    using Counters for Counters.Counter;

    bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");
    bytes32 public constant ISSUER_ROLE = keccak256("ISSUER_ROLE");
    bytes32 public constant GENESIS_ROLE = keccak256("GENESIS_ROLE");

    Counters.Counter private _assetIdCounter;

    struct Asset {
        uint256 assetId;
        address owner;
        string name;
        string assetType;
        string location;
        uint256 totalShares;
        address nftAddress;
        address fractionalToken;
        bool active;
        uint256 issuedAt;
    }

    mapping(uint256 => Asset) public assets;
    mapping(address => bool) public genesisHolders;

    event AssetTokenized(uint256 indexed assetId, address indexed owner, string name, string assetType, string location);
    event SharesMinted(uint256 indexed assetId, address indexed to, uint256 amount);
    event EscrowReleased(uint256 indexed assetId, address indexed beneficiary);
    event REPAwarded(address indexed user, uint256 amount, string reason);

    function initialize(address admin) public initializer {
        __AccessControl_init();
        __UUPSUpgradeable_init();
        _grantRole(DEFAULT_ADMIN_ROLE, admin);
        _grantRole(ADMIN_ROLE, admin);
        _grantRole(ISSUER_ROLE, admin);
    }

    function registerGenesisHolder(address holder) external onlyRole(ADMIN_ROLE) {
        genesisHolders[holder] = true;
        _grantRole(GENESIS_ROLE, holder);
    }

    function tokenizeAsset(
        string memory name,
        string memory assetType,
        string memory location,
        uint256 totalShares,
        string memory tokenURI
    ) external onlyRole(ISSUER_ROLE) returns (uint256) {
        require(bytes(name).length > 0, "Name required");
        require(totalShares > 1, "Total shares must be > 1");

        uint256 assetId = _assetIdCounter.current();
        _assetIdCounter.increment();

        MosaicAsset nft = new MosaicAsset(name, "MOS-NFT", tokenURI);
        nft.mint(msg.sender, assetId);

        MosaicFractionalToken shares = new MosaicFractionalToken(
            string(abi.encodePacked(name, " Shares")),
            "MSHARE",
            totalShares
        );

        assets[assetId] = Asset({
            assetId: assetId,
            owner: msg.sender,
            name: name,
            assetType: assetType,
            location: location,
            totalShares: totalShares,
            nftAddress: address(nft),
            fractionalToken: address(shares),
            active: true,
            issuedAt: block.timestamp
        });

        emit AssetTokenized(assetId, msg.sender, name, assetType, location);

        uint256 repReward = genesisHolders[msg.sender] ? 200 : 100;
        emit REPAwarded(msg.sender, repReward, "RWA Tokenization");

        return assetId;
    }

    function getAsset(uint256 assetId) external view returns (Asset memory) {
        return assets[assetId];
    }

    function getTotalAssets() external view returns (uint256) {
        return _assetIdCounter.current();
    }

    function _authorizeUpgrade(address) internal override onlyRole(ADMIN_ROLE) {}
}

contract MosaicAsset is ERC721 {
    string private baseURI;

    constructor(string memory name, string memory symbol, string memory _baseURI) ERC721(name, symbol) {
        baseURI = _baseURI;
    }

    function mint(address to, uint256 tokenId) external {
        _safeMint(to, tokenId);
    }

    function _baseURI() internal view override returns (string memory) {
        return baseURI;
    }
}

contract MosaicFractionalToken is ERC20 {
    constructor(string memory name, string memory symbol, uint256 initialSupply) ERC20(name, symbol) {
        _mint(msg.sender, initialSupply);
    }
}
