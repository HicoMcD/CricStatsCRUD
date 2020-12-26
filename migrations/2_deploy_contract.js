const CricStatsCRUD = artifacts.require("CricStatsCRUD");

module.exports = function(deployer) {
  deployer.deploy(CricStatsCRUD);
};