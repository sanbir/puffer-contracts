// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0 <0.9.0;

import "forge-std/Script.sol";
import "forge-std/console2.sol";
import { stdJson } from "forge-std/StdJson.sol";
import { Strings } from "@openzeppelin/contracts/utils/Strings.sol";
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
    using stdJson for string;

    address public ssvNtworkAddress = 0xDD9BC35aE942eF0cFa76930954a156B3fF30a4E1;
    address public safe = 0x759C1d68eaEb808Bb56519D59A1F49244086A892;

    struct Tx {
        address to;
        bytes data;
    }

    uint256 constant count = 1;

    function run() public {
        string memory root = vm.projectRoot();
        string memory path = string.concat(root, "/registration-data/safe_puffer.json");
        string memory json = vm.readFile(path);

        Tx[] memory transactions = new Tx[](count);
        for (uint256 i = 0; i < count; i++) {
            transactions[i] = getTx(i, json);
        }

        _createSafeJson(safe, transactions);
    }

    function getCluster(uint256 i) internal returns(ISSVClusters.Cluster memory cluster) {
        if (i == 0) {
            cluster = ISSVClusters.Cluster({
                validatorCount: 500,
                networkFeeIndex: 90505968494,
                index: 0,
                active: true,
                balance: 78831318327500000000
            });
        }  else if (i == 1) {
            cluster = ISSVClusters.Cluster({
                validatorCount: 500,
                networkFeeIndex: 90512187769,
                index: 0,
                active: true,
                balance: 78825840072500000000
            });
        } else if (i == 2) {
            cluster = ISSVClusters.Cluster({
                validatorCount: 500,
                networkFeeIndex: 90486040349,
                index: 0,
                active: true,
                balance: 78824530055000000000
            });
        } else {
            revert("No cluster");
        }
    }

    function getTx(uint256 i, string memory json) internal returns(Tx memory tx) {
        address owner = json.readAddress(string.concat(".arr[", vm.toString(i), "].owner"));
        console2.logAddress(owner);
        uint256[] memory operator_ids = json.readUintArray(string.concat(".arr[", vm.toString(i), "].operator_ids"));
        bytes[] memory pubkeys = json.readBytesArray(string.concat(".arr[", vm.toString(i), "].pubkeys"));

        uint64[] memory operatorIds = new uint64[](4);
        operatorIds[0] = uint64(operator_ids[0]);
        operatorIds[1] = uint64(operator_ids[1]);
        operatorIds[2] = uint64(operator_ids[2]);
        operatorIds[3] = uint64(operator_ids[3]);

        // ISSVClusters.Cluster memory cluster = getCluster(i);

        bytes memory bulkExitValidatorCalldata = abi.encodeCall(
            ISSVClusters.bulkExitValidator,
            (pubkeys, operatorIds)
        );

        tx = Tx({ to: ssvNtworkAddress, data: bulkExitValidatorCalldata });
    }

    function _createSafeJson(address safe, Tx[] memory transactions) internal {
        // First we need to craft the JSON file for the transactions batch
        string memory root = "root";

        vm.serializeString(root, "version", "1.0");
        vm.serializeUint(root, "createdAt", block.timestamp * 1000);
        // Needs to be a string
        vm.serializeString(root, "chainId", "1");

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
