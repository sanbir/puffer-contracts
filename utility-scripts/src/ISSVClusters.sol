// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity 0.8.26;

interface ISSVClusters {
    /// @notice Represents a cluster of validators
    struct Cluster {
        /// @dev The number of validators in the cluster
        uint32 validatorCount;
        /// @dev The index of network fees related to this cluster
        uint64 networkFeeIndex;
        /// @dev The last index calculated for the cluster
        uint64 index;
        /// @dev Flag indicating whether the cluster is active
        bool active;
        /// @dev The balance of the cluster
        uint256 balance;
    }

    /// @notice Bulk removes a set of existing validators in the same cluster from the SSV Network
    /// @notice Reverts if publicKeys contains duplicates or non-existent validators
    /// @param publicKeys The public keys of the validators to be removed
    /// @param operatorIds Array of IDs of operators managing the validator
    /// @param cluster Cluster associated with the validator
    function bulkRemoveValidator(
        bytes[] calldata publicKeys,
        uint64[] memory operatorIds,
        Cluster memory cluster
    ) external;

    /**
     * @dev Emitted when the validator is removed.
     * @param publicKey The public key of a validator.
     * @param operatorIds The operator ids list.
     * @param cluster All the cluster data.
     */
    event ValidatorRemoved(address indexed owner, uint64[] operatorIds, bytes publicKey, Cluster cluster);

    /// @notice Fires the exit event for a set of validators
    /// @param publicKeys The public keys of the validators to be exited
    /// @param operatorIds Array of IDs of operators managing the validators
    function bulkExitValidator(bytes[] calldata publicKeys, uint64[] calldata operatorIds) external;

    /**
     * @dev Emitted when a validator begins the exit process.
     * @param owner The owner of the exiting validator.
     * @param operatorIds The operator IDs managing the validator.
     * @param publicKey The public key of the exiting validator.
     */
    event ValidatorExited(address indexed owner, uint64[] operatorIds, bytes publicKey);
}
