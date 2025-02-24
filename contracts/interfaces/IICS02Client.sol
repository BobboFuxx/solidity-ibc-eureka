// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import { IICS02ClientMsgs } from "../msgs/IICS02ClientMsgs.sol";
import { ILightClientMsgs } from "../msgs/ILightClientMsgs.sol";
import { ILightClient } from "./ILightClient.sol";

/// @title ICS02 Light Client Router Interface
/// @notice IICS02Client is an interface for the IBC Eureka client router
interface IICS02Client {
    /// @notice Emitted when a new client is added to the client router.
    /// @param clientId The newly created client identifier
    /// @param counterpartyInfo The counterparty client information, if provided
    event ICS02ClientAdded(string clientId, IICS02ClientMsgs.CounterpartyInfo counterpartyInfo);

    /// @notice Returns the counterparty client information given the client identifier.
    /// @param clientId The client identifier
    /// @return The counterparty client information
    function getCounterparty(string calldata clientId)
        external
        view
        returns (IICS02ClientMsgs.CounterpartyInfo memory);

    /// @notice Returns the address of the client contract given the client identifier.
    /// @param clientId The client identifier
    /// @return The address of the client contract
    function getClient(string calldata clientId) external view returns (ILightClient);

    /// @notice Returns the next client sequence number.
    /// @dev This function can be used to determine when to stop iterating over clients.
    /// @return The next client sequence number
    function getNextClientSeq() external view returns (uint256);

    /// @notice Adds a client to the client router.
    /// @param counterpartyInfo The counterparty client information
    /// @param client The address of the client contract
    /// @return The client identifier
    function addClient(
        IICS02ClientMsgs.CounterpartyInfo calldata counterpartyInfo,
        address client
    )
        external
        returns (string memory);

    /// @notice Migrate the underlying client of the subject client to the substitute client.
    /// @dev This is a privilaged operation, only the owner of ICS02Client can call this function.
    /// @param subjectClientId The client identifier of the subject client
    /// @param substituteClientId The client identifier of the substitute client
    function migrateClient(string calldata subjectClientId, string calldata substituteClientId) external;

    /// @notice Updates the client given the client identifier.
    /// @param clientId The client identifier
    /// @param updateMsg The update message
    /// @return The result of the update operation
    function updateClient(
        string calldata clientId,
        bytes calldata updateMsg
    )
        external
        returns (ILightClientMsgs.UpdateResult);

    /// @notice Submits misbehaviour to the client with the given client identifier.
    /// @param clientId The client identifier
    /// @param misbehaviourMsg The misbehaviour message
    function submitMisbehaviour(string calldata clientId, bytes calldata misbehaviourMsg) external;

    /// @notice Upgrades the client with the given client identifier.
    /// @param clientId The client identifier
    /// @param upgradeMsg The upgrade message
    function upgradeClient(string calldata clientId, bytes calldata upgradeMsg) external;

    /// @notice Returns the role identifier for a light client
    /// @param clientId The client identifier
    /// @return The role identifier
    function getLightClientMigratorRole(string memory clientId) external view returns (bytes32);
}
