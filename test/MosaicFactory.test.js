const { expect } = require("chai");
const { ethers, upgrades } = require("hardhat");

describe("MosaicFactory", function () {
  let mosaicFactory;
  let owner;
  let issuer;
  let genesisHolder;
  let addr1;

  beforeEach(async function () {
    [owner, issuer, genesisHolder, addr1] = await ethers.getSigners();

    const MosaicFactory = await ethers.getContractFactory("MosaicFactory");
    mosaicFactory = await upgrades.deployProxy(MosaicFactory, [owner.address], {
      initializer: "initialize",
    });

    const ISSUER_ROLE = await mosaicFactory.ISSUER_ROLE();
    await mosaicFactory.grantRole(ISSUER_ROLE, issuer.address);
  });

  describe("Asset Tokenization", function () {
    it("Should tokenize an asset", async function () {
      const tx = await mosaicFactory.connect(issuer).tokenizeAsset(
        "Real Estate Property",
        "RealEstate",
        "Lagos, Nigeria",
        1000,
        "ipfs://QmXXXXXX"
      );

      await tx.wait();
      const asset = await mosaicFactory.getAsset(0);
      expect(asset.name).to.equal("Real Estate Property");
      expect(asset.assetType).to.equal("RealEstate");
      expect(asset.owner).to.equal(issuer.address);
    });

    it("Should revert if name is empty", async function () {
      await expect(
        mosaicFactory.connect(issuer).tokenizeAsset(
          "",
          "RealEstate",
          "Lagos, Nigeria",
          1000,
          "ipfs://QmXXXXXX"
        )
      ).to.be.revertedWith("Name required");
    });

    it("Should revert if shares are <= 1", async function () {
      await expect(
        mosaicFactory.connect(issuer).tokenizeAsset(
          "Real Estate Property",
          "RealEstate",
          "Lagos, Nigeria",
          1,
          "ipfs://QmXXXXXX"
        )
      ).to.be.revertedWith("Total shares must be > 1");
    });
  });

  describe("Genesis Holders", function () {
    it("Should register genesis holder", async function () {
      await mosaicFactory.registerGenesisHolder(genesisHolder.address);
      expect(await mosaicFactory.genesisHolders(genesisHolder.address)).to.be.true;
    });

    it("Should award 200 REP for genesis holder", async function () {
      const ISSUER_ROLE = await mosaicFactory.ISSUER_ROLE();
      await mosaicFactory.grantRole(ISSUER_ROLE, genesisHolder.address);
      await mosaicFactory.registerGenesisHolder(genesisHolder.address);

      const tx = await mosaicFactory.connect(genesisHolder).tokenizeAsset(
        "Asset",
        "RealEstate",
        "Lagos, Nigeria",
        1000,
        "ipfs://QmXXXXXX"
      );

      const receipt = await tx.wait();
      const repEvent = receipt.events.find((e) => e.event === "REPAwarded");
      expect(repEvent.args.amount).to.equal(200);
    });
  });

  describe("Asset Retrieval", function () {
    it("Should get total assets count", async function () {
      await mosaicFactory.connect(issuer).tokenizeAsset(
        "Asset 1",
        "RealEstate",
        "Lagos, Nigeria",
        1000,
        "ipfs://QmXXXXXX"
      );

      await mosaicFactory.connect(issuer).tokenizeAsset(
        "Asset 2",
        "PalmOil",
        "Ivory Coast",
        500,
        "ipfs://QmYYYYYY"
      );

      expect(await mosaicFactory.getTotalAssets()).to.equal(2);
    });
  });
});
