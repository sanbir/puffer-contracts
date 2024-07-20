// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0 <0.9.0;

import "forge-std/Script.sol";
import { stdJson } from "forge-std/StdJson.sol";
import { Strings } from "@openzeppelin/contracts/utils/Strings.sol";
import { ERC20 } from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "../src/ISSVClusters.sol";
import "../src/IP2pSsvProxyFactory.sol";

/**
 * See the docs for more detailed information: https://docs.puffer.fi/nodes/registration#batch-registering-validators
 *
 *  To run the simulation:
 *
 * forge script script/GenerateBLSKeysAndRegisterValidatorsCalldata.s.sol:GenerateBLSKeysAndRegisterValidatorsCalldata --rpc-url=$RPC_URL -vvv --ffi
 *
 */
contract GenerateBLSKeysAndRegisterValidatorsCalldata is Script {
    address public ssvNtworkAddress = 0x38A4794cCEd47d3baf7370CcC43B560D3a1beEFA;
    address public safe = 0x9aB843F2d60be2316F42B9764e98b532908AaB37;

    address public p2pSsvProxyFactoryAddress = 0x87A11cF5aFF0a46A7Ffb4C00b497aa3a73015d51;

    struct Tx {
        address to;
        bytes data;
    }

    function run() public {
//        Tx[] memory transactions = new Tx[](4);
//        transactions[0] = getTx1();
//        transactions[1] = getTx2();
//        transactions[2] = getTx3();
//        transactions[3] = getTx4();

        Tx[] memory transactions = new Tx[](2);
        transactions[0] = getTx__TEST1();
        transactions[1] = getTx__TEST2();

        _createSafeJson(safe, transactions);
    }

    function getTx1() internal returns(Tx memory tx) {
        bytes[] memory publicKeys = new bytes[](7);
        publicKeys[0] = bytes(hex'8ae430787d3cb55093dba32d4f5e7736c48d494121dc6ed5520182490b977af7ddc0ecc586296fc315f9553dd07c5486');
        publicKeys[1] = bytes(hex'b87798a82ca43743b7b726bdad694c8c9b76b68023bde42cf97a0e4d0da7e3604d4b436b9db44ef5e56106626d95ef68');
        publicKeys[2] = bytes(hex'a3e789d3b378c42a3c963ef549b739ca55d1cdc7211aa22ebf382e4e847ea23f12c5a5131aa835afe5743432b02df806');
        publicKeys[3] = bytes(hex'8171e4c04ea01ab1a84746527e33fdc739ad118946ba3f1cee356f3b35e9642304a7efffd1e4db4aa556ce333687ea11');
        publicKeys[4] = bytes(hex'95dc732567172754d9a1764b0ce4aefba1c25d82983d964bafd26e8776c8b8197695b569b00321fa581eb70d528bca57');
        publicKeys[5] = bytes(hex'92269be7b88c417f46aafd18943783990df0952c9858bd3147815e31f48d1be5f559387b696231f98fcc5ca2b3ff354e');
        publicKeys[6] = bytes(hex'a413b93c25f77d27c5edab2b131d06bc90215c3eb2761309fdac35b0c76e12dccf45788a7ca0228b591cafb8626ab01a');

        uint64[] memory operatorIds = new uint64[](4);
        operatorIds[0] = 42;
        operatorIds[0] = 43;
        operatorIds[0] = 44;
        operatorIds[0] = 45;

        ISSVClusters.Cluster memory cluster = ISSVClusters.Cluster({
            validatorCount: 5,
            networkFeeIndex: 61300535088,
            index: 262565454206,
            active: true,
            balance: 53460049500000000000
        });

        bytes memory bulkRemoveValidatorCalldata = abi.encodeCall(
            ISSVClusters.bulkRemoveValidator,
            (publicKeys, operatorIds, cluster)
        );

        tx = Tx({ to: ssvNtworkAddress, data: bulkRemoveValidatorCalldata });
    }

    function getTx2() internal returns(Tx memory tx) {
        bytes[] memory publicKeys = new bytes[](7);
        publicKeys[0] = bytes(hex'8ae430787d3cb55093dba32d4f5e7736c48d494121dc6ed5520182490b977af7ddc0ecc586296fc315f9553dd07c5486');
        publicKeys[1] = bytes(hex'b87798a82ca43743b7b726bdad694c8c9b76b68023bde42cf97a0e4d0da7e3604d4b436b9db44ef5e56106626d95ef68');
        publicKeys[2] = bytes(hex'a3e789d3b378c42a3c963ef549b739ca55d1cdc7211aa22ebf382e4e847ea23f12c5a5131aa835afe5743432b02df806');
        publicKeys[3] = bytes(hex'8171e4c04ea01ab1a84746527e33fdc739ad118946ba3f1cee356f3b35e9642304a7efffd1e4db4aa556ce333687ea11');
        publicKeys[4] = bytes(hex'95dc732567172754d9a1764b0ce4aefba1c25d82983d964bafd26e8776c8b8197695b569b00321fa581eb70d528bca57');
        publicKeys[5] = bytes(hex'92269be7b88c417f46aafd18943783990df0952c9858bd3147815e31f48d1be5f559387b696231f98fcc5ca2b3ff354e');
        publicKeys[6] = bytes(hex'a413b93c25f77d27c5edab2b131d06bc90215c3eb2761309fdac35b0c76e12dccf45788a7ca0228b591cafb8626ab01a');

        uint64[] memory operatorIds = new uint64[](4);
        operatorIds[0] = 42;
        operatorIds[0] = 43;
        operatorIds[0] = 44;
        operatorIds[0] = 45;

        ISSVClusters.Cluster memory cluster = ISSVClusters.Cluster({
            validatorCount: 5,
            networkFeeIndex: 61300535088,
            index: 262565454206,
            active: true,
            balance: 53460049500000000000
        });

        bytes memory bulkRemoveValidatorCalldata = abi.encodeCall(
            ISSVClusters.bulkRemoveValidator,
            (publicKeys, operatorIds, cluster)
        );

        tx = Tx({ to: ssvNtworkAddress, data: bulkRemoveValidatorCalldata });
    }

    function getTx3() internal returns(Tx memory tx) {
        bytes[] memory publicKeys = new bytes[](7);
        publicKeys[0] = bytes(hex'8ae430787d3cb55093dba32d4f5e7736c48d494121dc6ed5520182490b977af7ddc0ecc586296fc315f9553dd07c5486');
        publicKeys[1] = bytes(hex'b87798a82ca43743b7b726bdad694c8c9b76b68023bde42cf97a0e4d0da7e3604d4b436b9db44ef5e56106626d95ef68');
        publicKeys[2] = bytes(hex'a3e789d3b378c42a3c963ef549b739ca55d1cdc7211aa22ebf382e4e847ea23f12c5a5131aa835afe5743432b02df806');
        publicKeys[3] = bytes(hex'8171e4c04ea01ab1a84746527e33fdc739ad118946ba3f1cee356f3b35e9642304a7efffd1e4db4aa556ce333687ea11');
        publicKeys[4] = bytes(hex'95dc732567172754d9a1764b0ce4aefba1c25d82983d964bafd26e8776c8b8197695b569b00321fa581eb70d528bca57');
        publicKeys[5] = bytes(hex'92269be7b88c417f46aafd18943783990df0952c9858bd3147815e31f48d1be5f559387b696231f98fcc5ca2b3ff354e');
        publicKeys[6] = bytes(hex'a413b93c25f77d27c5edab2b131d06bc90215c3eb2761309fdac35b0c76e12dccf45788a7ca0228b591cafb8626ab01a');

        uint64[] memory operatorIds = new uint64[](4);
        operatorIds[0] = 42;
        operatorIds[0] = 43;
        operatorIds[0] = 44;
        operatorIds[0] = 45;

        ISSVClusters.Cluster memory cluster = ISSVClusters.Cluster({
            validatorCount: 5,
            networkFeeIndex: 61300535088,
            index: 262565454206,
            active: true,
            balance: 53460049500000000000
        });

        bytes memory bulkRemoveValidatorCalldata = abi.encodeCall(
            ISSVClusters.bulkRemoveValidator,
            (publicKeys, operatorIds, cluster)
        );

        tx = Tx({ to: ssvNtworkAddress, data: bulkRemoveValidatorCalldata });
    }

    function getTx4() internal returns(Tx memory tx) {
        bytes[] memory publicKeys = new bytes[](7);
        publicKeys[0] = bytes(hex'8ae430787d3cb55093dba32d4f5e7736c48d494121dc6ed5520182490b977af7ddc0ecc586296fc315f9553dd07c5486');
        publicKeys[1] = bytes(hex'b87798a82ca43743b7b726bdad694c8c9b76b68023bde42cf97a0e4d0da7e3604d4b436b9db44ef5e56106626d95ef68');
        publicKeys[2] = bytes(hex'a3e789d3b378c42a3c963ef549b739ca55d1cdc7211aa22ebf382e4e847ea23f12c5a5131aa835afe5743432b02df806');
        publicKeys[3] = bytes(hex'8171e4c04ea01ab1a84746527e33fdc739ad118946ba3f1cee356f3b35e9642304a7efffd1e4db4aa556ce333687ea11');
        publicKeys[4] = bytes(hex'95dc732567172754d9a1764b0ce4aefba1c25d82983d964bafd26e8776c8b8197695b569b00321fa581eb70d528bca57');
        publicKeys[5] = bytes(hex'92269be7b88c417f46aafd18943783990df0952c9858bd3147815e31f48d1be5f559387b696231f98fcc5ca2b3ff354e');
        publicKeys[6] = bytes(hex'a413b93c25f77d27c5edab2b131d06bc90215c3eb2761309fdac35b0c76e12dccf45788a7ca0228b591cafb8626ab01a');

        uint64[] memory operatorIds = new uint64[](4);
        operatorIds[0] = 42;
        operatorIds[0] = 43;
        operatorIds[0] = 44;
        operatorIds[0] = 45;

        ISSVClusters.Cluster memory cluster = ISSVClusters.Cluster({
            validatorCount: 5,
            networkFeeIndex: 61300535088,
            index: 262565454206,
            active: true,
            balance: 53460049500000000000
        });

        bytes memory bulkRemoveValidatorCalldata = abi.encodeCall(
            ISSVClusters.bulkRemoveValidator,
            (publicKeys, operatorIds, cluster)
        );

        tx = Tx({ to: ssvNtworkAddress, data: bulkRemoveValidatorCalldata });
    }

    function getTx__TEST1() internal returns(Tx memory tx) {
        bytes memory setMaxSsvTokenAmountPerValidatorCalldata = abi.encodeCall(
            IP2pSsvProxyFactory.setMaxSsvTokenAmountPerValidator,
            (50 ether)
        );

        tx = Tx({ to: p2pSsvProxyFactoryAddress, data: setMaxSsvTokenAmountPerValidatorCalldata });
    }

    function getTx__TEST2() internal returns(Tx memory tx) {
        bytes4[] memory selectors = new bytes4[](2);
        selectors[0] = 0x6a761203;
        selectors[1] = 0x6a761204;

        bytes memory setAllowedSelectorsForOperatorCalldata = abi.encodeCall(
            IP2pSsvProxyFactory.setAllowedSelectorsForOperator,
            (selectors)
        );

        tx = Tx({ to: p2pSsvProxyFactoryAddress, data: setAllowedSelectorsForOperatorCalldata });
    }

    function _createSafeJson(address safe, Tx[] memory transactions) internal {
        // First we need to craft the JSON file for the transactions batch
        string memory root = "root";

        vm.serializeString(root, "version", "1.0");
        vm.serializeUint(root, "createdAt", block.timestamp * 1000);
        // Needs to be a string
        vm.serializeString(root, "chainId", Strings.toString(block.chainid));

        string memory meta = "meta";
        vm.serializeString(meta, "name", "Transactions Batch");
        vm.serializeString(meta, "txBuilderVersion", "1.16.5");
        vm.serializeAddress(meta, "createdFromSafeAddress", safe);
        vm.serializeString(meta, "createdFromOwnerAddress", "");
        vm.serializeString(meta, "checksum", "");
        string memory metaOutput = vm.serializeString(meta, "description", "");

        string[] memory txs = new string[](transactions.length);

        for (uint256 i = 0; i < transactions.length; ++i) {
            string memory singleTx = "tx";

            vm.serializeAddress(singleTx, "to", transactions[i].to);
            vm.serializeString(singleTx, "value", "0");
            txs[i] = vm.serializeBytes(singleTx, "data", transactions[i].data);
        }

        vm.serializeString(root, "transactions", txs);
        string memory finalJson = vm.serializeString(root, "meta", metaOutput);
        vm.writeJson(finalJson, "./safe-registration-file.json");

        // Because foundry doesn't support creating JSON array of objects, we need to run NodeJS script to convert this to a valid JSON

        string[] memory inputs = new string[](2);
        inputs[0] = "node";
        inputs[1] = "parse-foundry-json";
        vm.ffi(inputs);
    }
}
