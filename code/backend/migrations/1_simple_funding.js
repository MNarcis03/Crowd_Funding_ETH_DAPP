const CrowdFunding = artifacts.require("./CrowdFunding.sol");
const DistributeFunding = artifacts.require("./DistributeFunding.sol");

module.exports = function(deployer) {
    deployer.deploy(CrowdFunding);
    deployer.deploy(DistributeFunding);
};
