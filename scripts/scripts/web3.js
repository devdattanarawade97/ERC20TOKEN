// Import the ABIs, see: https://docs.aave.com/developers/developing-on-aave/deployed-contract-instances
const Web3= require('web3');
import PizzaBitesToken from "./contracts/artifacts/PizzaBitesToken.json"
import LendingPoolAddressesProviderABI from "./LendingPoolAddressesProvider.json"
import LendingPoolABI from "./LendingPool.json"




// Input variables
const PBTAmountinWei = Web3.utils.toWei("1", "ether").toString()
const PizzaBitesTokenAddress = '0x6B175474E89094C44Da98b954EedeAC495271d0F' // 
const referralCode = '0'
const userAddress = 'YOUR_WALLET_ADDRESS'

const lpAddressProviderAddress = '0x24a42fD28C976A61Df5D00D0599C34c4f90748c8' // mainnet address, for other addresses: https://docs.aave.com/developers/developing-on-aave/deployed-contract-instances
const lpAddressProviderContract = new Web3.eth.Contract(LendingPoolAddressesProviderABI, lpAddressProviderAddress)

// Get the latest LendingPoolCore address


async function lpCoreAddress(){
 await lpAddressProviderContract.methods
    .getLendingPoolCore()
    .call()
    .catch((e) => {
        throw Error(`Error getting lendingPool address: ${e.message}`)
    })

}


// Approve the LendingPoolCore address with the contract
const Contract = new Web3.eth.Contract(PizzaBitesToken, PizzaBitesTokenAddress)
  
async function approve(){
    await Contract.methods
    .approve(
        lpCoreAddress,
        PBTAmountinWei
    )
    .send()
    .catch((e) => {
        throw Error(`Error approving DAI allowance: ${e.message}`)
    })
}

// Get the latest LendingPool contract address
const lpaddress=async function lendingPoolAddress(){

    await lpAddressProviderContract.methods
    .getLendingPool()
    .call()
    .catch((e) => {
        throw Error(`Error getting lendingPool address: ${e.message}`)
    })
}
 
// Make the deposit transaction via LendingPool contract

async function deposit(){
    new Web3.eth.Contract(LendingPoolABI, lpaddress)
await Contract.methods
    .deposit(
        PizzaBitesTokenAddress,
        PBTAmountinWei,
        referralCode
    )
    .send()
    .catch((e) => {
        throw Error(`Error depositing to the LendingPool contract: ${e.message}`)
    })

}

deposit();