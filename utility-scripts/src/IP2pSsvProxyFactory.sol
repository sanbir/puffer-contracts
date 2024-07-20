// SPDX-FileCopyrightText: 2024 P2P Validator <info@p2p.org>
// SPDX-License-Identifier: MIT

pragma solidity 0.8.26;

/// @dev External interface of P2pSsvProxyFactory
interface IP2pSsvProxyFactory {

    /// @notice Emits when batch registration of validator with SSV is completed
    /// @param _proxy address of P2pSsvProxy that was used for registration and became the cluster owner
    event P2pSsvProxyFactory__RegistrationCompleted(
        address indexed _proxy
    );

    /// @notice Emits when a new P2pSsvProxy instance was deployed and initialized
    /// @param _p2pSsvProxy newly deployed P2pSsvProxy instance address
    /// @param _client client address
    /// @param _feeDistributor FeeDistributor instance address
    event P2pSsvProxyFactory__P2pSsvProxyCreated(
        address indexed _p2pSsvProxy,
        address indexed _client,
        address indexed _feeDistributor
    );

    /// @notice Emits when a new reference FeeDistributor has been set
    /// @param _referenceFeeDistributor new reference FeeDistributor address
    event P2pSsvProxyFactory__ReferenceFeeDistributorSet(
        address indexed _referenceFeeDistributor
    );

    /// @notice Emits when a new value for ssvPerEthExchangeRateDividedByWei has been set
    /// @param _ssvPerEthExchangeRateDividedByWei new value for ssvPerEthExchangeRateDividedByWei
    event P2pSsvProxyFactory__SsvPerEthExchangeRateDividedByWeiSet(
        uint112 _ssvPerEthExchangeRateDividedByWei
    );

    /// @notice Emits when a new value for maximum amount of SSV tokens per validator has been set
    /// @param _maxSsvTokenAmountPerValidator new value for maximum amount of SSV tokens per validator
    event P2pSsvProxyFactory__MaxSsvTokenAmountPerValidatorSet(
        uint112 _maxSsvTokenAmountPerValidator
    );

    /// @notice Emits when a new reference P2pSsvProxy has been set
    /// @param _referenceP2pSsvProxy new reference P2pSsvProxy address
    event P2pSsvProxyFactory__ReferenceP2pSsvProxySet(
        address indexed _referenceP2pSsvProxy
    );

    /// @notice Emits when new selectors were allowed for clients
    /// @param _selectors newly allowed selectors
    event P2pSsvProxyFactory__AllowedSelectorsForClientSet(
        bytes4[] _selectors
    );

    /// @notice Emits when selectors were disallowed for clients
    /// @param _selectors disallowed selectors
    event P2pSsvProxyFactory__AllowedSelectorsForClientRemoved(
        bytes4[] _selectors
    );

    /// @notice Emits when new selectors were allowed for operator
    /// @param _selectors newly allowed selectors
    event P2pSsvProxyFactory__AllowedSelectorsForOperatorSet(
        bytes4[] _selectors
    );

    /// @notice Emits when selectors were disallowed for operator
    /// @param _selectors disallowed selectors
    event P2pSsvProxyFactory__AllowedSelectorsForOperatorRemoved(
        bytes4[] _selectors
    );

    /// @notice Emits when new SSV operator owner addresses have been allowed
    /// @param _allowedSsvOperatorOwners newly allowed SSV operator owner addresses
    event P2pSsvProxyFactory__AllowedSsvOperatorOwnersSet(
        address[] _allowedSsvOperatorOwners
    );

    /// @notice Emits when some SSV operator owner addresses have been removed from the allowlist
    /// @param _allowedSsvOperatorOwners disallowed SSV operator owner addresses
    event P2pSsvProxyFactory__AllowedSsvOperatorOwnersRemoved(
        address[] _allowedSsvOperatorOwners
    );

    /// @notice Emits when operator IDs list has been cleared for the given SSV operator owner
    /// @param _ssvOperatorOwner SSV operator owner
    event P2pSsvProxyFactory__SsvOperatorIdsCleared(
        address indexed _ssvOperatorOwner
    );

    /// @notice Emits when client deposited their ETH for SSV staking
    /// @param _depositId ID of client deposit (derived from ETH2 WithdrawalCredentials, ETH amount per validator in wei, fee distributor instance address)
    /// @param _sender address who sent ETH
    /// @param _p2pSsvProxy address of the client instance of P2pSsvProxy
    /// @param _feeDistributorInstance address of the client instance of FeeDistributor
    /// @param _ethAmountInWei amount of deposited ETH in wei
    event P2pSsvProxyFactory__EthForSsvStakingDeposited(
        bytes32 indexed _depositId,
        address indexed _sender,
        address indexed _p2pSsvProxy,
        address _feeDistributorInstance,
        uint256 _ethAmountInWei
    );

    /// @notice Set Exchange rate between SSV and ETH set by P2P.
    /// @dev (If 1 SSV = 0.007539 ETH, it should be 0.007539 * 10^18 = 7539000000000000).
    /// @param _ssvPerEthExchangeRateDividedByWei Exchange rate
    function setSsvPerEthExchangeRateDividedByWei(uint112 _ssvPerEthExchangeRateDividedByWei) external;

    /// @notice Set Maximum amount of SSV tokens per validator that is allowed for client to deposit during `depositEthAndRegisterValidators`
    /// @param _maxSsvTokenAmountPerValidator Maximum amount of SSV tokens per validator
    function setMaxSsvTokenAmountPerValidator(uint112 _maxSsvTokenAmountPerValidator) external;

    /// @notice Set template to be used for new P2pSsvProxy instances
    /// @param _referenceP2pSsvProxy template to be used for new P2pSsvProxy instances
    function setReferenceP2pSsvProxy(address _referenceP2pSsvProxy) external;

    /// @notice Allow selectors (function signatures) for clients to call on SSVNetwork via P2pSsvProxy
    /// @param _selectors selectors (function signatures) to allow for clients
    function setAllowedSelectorsForClient(bytes4[] calldata _selectors) external;

    /// @notice Disallow selectors (function signatures) for clients to call on SSVNetwork via P2pSsvProxy
    /// @param _selectors selectors (function signatures) to disallow for clients
    function removeAllowedSelectorsForClient(bytes4[] calldata _selectors) external;

    /// @notice Allow selectors (function signatures) for P2P operator to call on SSVNetwork via P2pSsvProxy
    /// @param _selectors selectors (function signatures) to allow for P2P operator
    function setAllowedSelectorsForOperator(bytes4[] calldata _selectors) external;

    /// @notice Disallow selectors (function signatures) for P2P operator to call on SSVNetwork via P2pSsvProxy
    /// @param _selectors selectors (function signatures) to disallow for P2P operator
    function removeAllowedSelectorsForOperator(bytes4[] calldata _selectors) external;

    /// @notice Set template to be used for new FeeDistributor instances
    /// @param _referenceFeeDistributor template to be used for new FeeDistributor instances
    function setReferenceFeeDistributor(
        address _referenceFeeDistributor
    ) external;

    /// @notice Allow addresses of SSV operator owners (both P2P and partners)
    /// @param _allowedSsvOperatorOwners addresses of SSV operator owners to allow
    function setAllowedSsvOperatorOwners(
        address[] calldata _allowedSsvOperatorOwners
    ) external;

    /// @notice Disallow addresses of SSV operator owners (both P2P and partners)
    /// @param _allowedSsvOperatorOwnersToRemove addresses of SSV operator owners to disallow
    function removeAllowedSsvOperatorOwners(
        address[] calldata _allowedSsvOperatorOwnersToRemove
    ) external;

    /// @notice Clear own SSV operator IDs list
    /// @dev To be called by SSV operator owner
    function clearSsvOperatorIds() external;

    /// @notice Clear SSV operator IDs list for a SSV operator owner
    /// @dev To be called by P2P
    /// @param _ssvOperatorOwner SSV operator owner
    function clearSsvOperatorIds(
        address _ssvOperatorOwner
    ) external;

    /// @notice Computes the address of a P2pSsvProxy created by `_createP2pSsvProxy` function
    /// @dev P2pSsvProxy instances are guaranteed to have the same address if _feeDistributorInstance is the same
    /// @param _feeDistributorInstance The address of FeeDistributor instance
    /// @return address client P2pSsvProxy instance that will be or has been deployed
    function predictP2pSsvProxyAddress(
        address _feeDistributorInstance
    ) external view returns (address);

    /// @notice Deploy P2pSsvProxy instance if not deployed before
    /// @param _feeDistributorInstance The address of FeeDistributor instance
    /// @return p2pSsvProxyInstance client P2pSsvProxy instance that has been deployed
    function createP2pSsvProxy(
        address _feeDistributorInstance
    ) external returns(address p2pSsvProxyInstance);

    /// @notice Returns the FeeDistributorFactory address
    /// @return FeeDistributorFactory address
    function getFeeDistributorFactory() external view returns (address);

    /// @notice A list of addresses of the deployed client P2pSsvProxy instances by client address
    /// @param _client client address
    /// @return A list of addresses of the deployed client P2pSsvProxy instances
    function getAllClientP2pSsvProxies(
        address _client
    ) external view returns (address[] memory);

    /// @notice Returns a list of all ever deployed client P2pSsvProxy instances
    /// @return a list of all ever deployed client P2pSsvProxy instances
    function getAllP2pSsvProxies() external view returns (address[] memory);

    /// @notice Returns if a certain selector (function signature) is allowed for clients to call on SSVNetwork via P2pSsvProxy
    /// @return True if allowed
    function isClientSelectorAllowed(bytes4 _selector) external view returns (bool);

    /// @notice Returns if a certain selector (function signature) is allowed for a P2P operator to call on SSVNetwork via P2pSsvProxy
    /// @param _selector selector (function signature)
    /// @return True if allowed
    function isOperatorSelectorAllowed(bytes4 _selector) external view returns (bool);

    /// @notice Returns a set of addresses of SSV operator owners (both P2P and partners)
    /// @return a set of addresses of SSV operator owners (both P2P and partners)
    function getAllowedSsvOperatorOwners() external view returns (address[] memory);

    /// @notice Returns a template set by P2P to be used for new FeeDistributor instances
    /// @return a template set by P2P to be used for new FeeDistributor instances
    function getReferenceFeeDistributor() external view returns (address);

    /// @notice Returns a template set by P2P to be used for new P2pSsvProxy instances
    /// @return a template set by P2P to be used for new P2pSsvProxy instances
    function getReferenceP2pSsvProxy() external view returns (address);

    /// @notice Returns exchange rate between SSV and ETH set by P2P
    /// @dev (If 1 SSV = 0.007539 ETH, it should be 0.007539 * 10^18 = 7539000000000000).
    /// Only used during validator registration without ETH deposits to cover SSV token costs with client ETH.
    /// SSV tokens exchanged with this rate cannot be withdrawn by the client.
    /// P2P is willing to tolarate potential discrepancies with the market exchange rate for the sake of simplicity.
    /// The client agrees to this rate when calls `registerValidators` function.
    /// @return exchange rate between SSV and ETH set by P2P
    function getSsvPerEthExchangeRateDividedByWei() external view returns (uint112);

    /// @notice Returns the maximum amount of SSV tokens per validator that is allowed for client to deposit during `depositEthAndRegisterValidators`
    /// @return maximum amount of SSV tokens per validator
    function getMaxSsvTokenAmountPerValidator() external view returns (uint112);

    /// @notice Returns needed amount of ETH to cover SSV fees by SSV token amount
    /// @param _tokenAmount SSV token amount
    /// @return needed amount of ETH to cover SSV fees
    function getNeededAmountOfEtherToCoverSsvFees(uint256 _tokenAmount) external view returns (uint256);
}
