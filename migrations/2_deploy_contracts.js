var Adoption = artifacts.require("Adoption");
var RPS = artifacts.require("RPS");

module.exports = function(deployer) {
  deployer.deploy(Adoption);
  deployer.deploy(RPS);
};