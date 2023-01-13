import chai, { expect } from "chai";
import asPromised from "chai-as-promised";
import * as dotenv from "dotenv";
import { utils } from "ethers";
dotenv.config();
import { ethers } from "hardhat";
import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";
import deploy from "../utils/deployed";
// @ts-ignore
import { STO } from "../typechain";
require("chai").use(require("chai-as-promised")).should();

chai.use(asPromised);

describe.only("Init Token", () => {
  let deployer: SignerWithAddress;
  let guest: SignerWithAddress;
  let token: STO;

  beforeEach(async () => {
    [deployer, guest] = await ethers.getSigners();
    token = await deploy.sto(
      deployer,
      "STO Token",
      "STO",
      deployer.address,
      100,
      1
    );
  });

  it("name", async () => {
    const name = await token.name();
    expect(name).to.eq("STO Token");
  });

  it("symbol", async () => {
    const name = await token.symbol();
    expect(name).to.eq("STO");
  });

  it("decimals", async () => {
    const decimals = await token.decimals();
    expect(decimals).to.eq(18);
  });

  it("supply", async () => {
    const totalSupply = await token.totalSupply();
    expect(totalSupply.toString()).to.eq(
      utils.parseEther("500000000").toString()
    );
  });

  it("transfer", async () => {
    await token.transfer(guest.address, utils.parseEther("100000000"));
    const totalSupplyUser = await token.balanceOf(guest.address);
    expect(totalSupplyUser.toString()).to.eq(
      utils.parseEther("100000000").toString()
    );
  });

  it.only("buy", async () => {
    await token
      .connect(guest)
      .invest({
        value: utils.parseEther("1"),
      })
      .should.be.rejectedWith("User is not in whitelist");
    await token.connect(deployer).addToWhitelist(guest.address);
    await token
      .connect(guest)
      .invest({
        value: utils.parseEther("0"),
      })
      .should.be.rejectedWith("Amount need over 0");
    await token
      .connect(guest)
      .invest({
        value: utils.parseEther("0.4"),
      })
      .should.be.rejectedWith("Amount need correct price");
    await token.connect(guest).invest({
      value: utils.parseEther("1"),
    });
    const result = await token.raised();
    expect(result.toString()).to.eq(utils.parseEther("1").toString());
    const balanceOf = await token.connect(guest).balanceOf(guest.address);
    expect(balanceOf.toString()).to.eq(utils.parseEther("1").toString());
  });
});
