const hre = require("hardhat");
const { ethers, upgrades } = require("hardhat");

async function main() {
  console.log("Deploying Mosaic RWA Platform...");

  const [deployer] = await ethers.getSigners();
  console.log(`Deploying contracts with account: ${deployer.address}`);

  const MosaicFactory = await ethers.getContractFactory("MosaicFactory");
  console.log("Deploying MosaicFactory...");
  const mosaicFactory = await upgrades.deployProxy(MosaicFactory, [deployer.address], {
    initializer: "initialize",
    kind: "uups",
  });

  await mosaicFactory.deployed();
  console.log(`✅ MosaicFactory deployed to: ${mosaicFactory.address}`);

  const ISSUER_ROLE = await mosaicFactory.ISSUER_ROLE();
  await mosaicFactory.grantRole(ISSUER_ROLE, deployer.address);
  console.log(`✅ Granted ISSUER_ROLE to deployer`);

  const deploymentInfo = {
    network: hre.network.name,
    deployer: deployer.address,
    mosaicFactory: mosaicFactory.address,
    deploymentTime: new Date().toISOString(),
  };

  console.log("\n=== Deployment Summary ===");
  console.log(JSON.stringify(deploymentInfo, null, 2));

  const fs = require("fs");
  const path = require("path");
  const deployDir = path.join(__dirname, "..", "deployments");
  if (!fs.existsSync(deployDir)) {
    fs.mkdirSync(deployDir, { recursive: true });
  }
  fs.writeFileSync(
    path.join(deployDir, `${hre.network.name}.json`),
    JSON.stringify(deploymentInfo, null, 2)
  );
  console.log(`✅ Deployment info saved to deployments/${hre.network.name}.json`);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
