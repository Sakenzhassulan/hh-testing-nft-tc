const { network } = require("hardhat")
const { developmentChains, networkConfig } = require("../helper-hardhat-config")
const { verify } = require("../utils/verify")
const fs = require("fs")

module.exports = async function ({ getNamedAccounts, deployments, getChainId }) {
    const { deploy, log } = deployments
    const { deployer } = await getNamedAccounts()
    const chainId = await getChainId()

    log("--------------------------------------")
    const arguments = []

    const myEmojiNFT = await deploy("MyEmojiNFT", {
        from: deployer,
        args: arguments,
        log: true,
        waitConfirmations: network.config.blockConfirmations || 1,
    })

    const myEmojiNFTContract = await ethers.getContractFactory("MyEmojiNFT")
    const accounts = await hre.ethers.getSigners()
    const signer = accounts[0]
    const myEmoji = new ethers.Contract(myEmojiNFT.address, myEmojiNFTContract.interface, signer)
    const networkName = networkConfig[chainId]["name"]

    log(`Verify with:\n npx hardhat verify --network ${networkName} ${myEmoji.address}`)

    // if (!developmentChains.includes(network.name) && process.env.ETHERSCAN_API_KEY) {
    //     log("Verifying...")
    //     await verify(myEmojiNFT.address, arguments)
    // }
    // log("--------------------------------------")
    let svg = fs.readFileSync("./images/emoji.svg", { encoding: "utf8" })
    tx = await myEmoji.mintNFT(svg)
    await tx.wait(1)
    log(`You've made your first NFT!`)
    log(`You can view the tokenURI here ${await myEmoji.tokenURI(0)}`)
}
module.exports.tags = ["all", "emojiNFT"]
