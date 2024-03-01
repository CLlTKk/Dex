require("@nomicfoundation/hardhat-toolbox");

const secret = "356f14542c671255a4cb79d90d6de71f957ea25d5fe7165ba069d760fbedce4e";
/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.20",
  networks:{
    testnet:{
      url: "https://bsc-testnet.publicnode.com",
      chainId: 97,
      gasPrice: 20000000000,
      secret: [secret]
    }
  },
  etherscan:{
    apikey:"RJWCMGIU73HMJ9HP3EFIUYP5NMC7IC2FDU"
  }
};
