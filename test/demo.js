const {
    time,
    loadFixture,
  } = require("@nomicfoundation/hardhat-toolbox/network-helpers");
  const { anyValue } = require("@nomicfoundation/hardhat-chai-matchers/withArgs");
  const { expect } = require("chai");

  
describe("DEMO", function(){
    async function deployFixture() {
        const [owner, otherAccount] = await ethers.getSigners();
    
        const Demo = await ethers.getContractFactory("MyNFT");

        const demo = await Demo.deploy();
    
        return { demo, owner, otherAccount };
    }

    describe("Deployment", function(){
        it("Should set owner correctly", async function(){
            const {demo, owner}= await loadFixture(deployFixture);
            expect(await demo.owner()).to.equal(owner.address);
        });
        it("Should set base URL correctly", async function(){
            const {demo, owner} = await loadFixture(deployFixture);
            expect(await demo._uri()).to.equal("https://ipfs.io/ipfs/QmWtYuyLhpa4NsyRz3HNHnMwzWdGggukC351C6yWnURTea/")
        });
    });
    describe("Mint", function(){
        it("Should mint NFT", async function(){
            const {demo, owner, otherAccount} = await loadFixture(deployFixture);
            expect(await demo.mint(otherAccount.address, 1, 100)).not.to.be.reverted;
            expect(await demo.balanceOf(otherAccount.address, 1)).to.equal(100);
        });
        it("Should revert if other users mints NFT", async function(){
            const {demo, owner, otherAccount} = await loadFixture(deployFixture);
            await expect(demo.connect(otherAccount).mint(otherAccount.address, 1, 100)).to.be.reverted;
        });
    });
    describe("Transfer", function(){
        it("Should transfer NFT to another user", async function(){
            const {demo, owner, otherAccount} = await loadFixture(deployFixture);
            await demo.mint(owner.address, 1,100);
            expect(await demo.safeTransferFrom(owner.address, otherAccount.address, 1, 50, "0x00")).not.to.be.reverted;
        });
        it("Should transfer NFT from another user", async function(){
            const {demo, owner, otherAccount} = await loadFixture(deployFixture);
            await demo.mint(otherAccount.address, 1,100);            
            expect(await demo.connect(otherAccount).setApprovalForAll(owner.address, true)).not.to.be.reverted;
            expect(await demo.safeTransferFrom(otherAccount.address, owner.address, 1, 50, "0x00")).not.to.be.reverted;
            expect(await demo.balanceOf(owner.address, 1)).to.be.equal(50);
        });
        it("Should revert if owner didn't make approve", async function(){
            const {demo, owner, otherAccount} = await loadFixture(deployFixture);
            await demo.mint(otherAccount.address, 1,100);            
            await expect(demo.safeTransferFrom(otherAccount.address,owner.address,  1, 50, "0x00")).to.be.reverted;
        });
    })
})