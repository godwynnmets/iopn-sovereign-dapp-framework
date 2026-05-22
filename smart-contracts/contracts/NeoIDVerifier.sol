// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./SovereignModule.sol";

/**
 * @title NeoIDVerifier
 * @dev Identity verification integration with NeoID system
 * Gated access for KYC/AML compliance
 */
contract NeoIDVerifier is SovereignModule {
    // KYC status enum
    enum KYCStatus {
        UNVERIFIED,
        PENDING,
        VERIFIED,
        REJECTED,
        EXPIRED
    }

    // Verification structure
    struct VerificationRecord {
        address user;
        KYCStatus status;
        uint256 verifiedAt;
        uint256 expiresAt;
        string verificationMethod;
        address verifier;
    }

    // State variables
    mapping(address => VerificationRecord) public verifications;
    mapping(address => bool) public isVerified;

    uint256 public verificationExpiry = 365 days; // 1 year validity

    // Events
    event IdentityVerified(
        address indexed user,
        KYCStatus status,
        uint256 expiresAt
    );
    event IdentityRevoked(address indexed user, string reason);
    event VerificationExpiryUpdated(uint256 newExpiry);

    /**
     * @dev Initialize NeoID verifier
     */
    function initialize(address admin, address operator) public override initializer {
        super.initialize(admin, operator);
    }

    /**
     * @dev Verify identity
     */
    function verifyIdentity(address user, string calldata method)
        external
        nonReentrant
        onlyRole(VERIFIER_ROLE)
    {
        require(user != address(0), "Invalid user address");

        uint256 expiresAt = block.timestamp + verificationExpiry;

        verifications[user] = VerificationRecord({
            user: user,
            status: KYCStatus.VERIFIED,
            verifiedAt: block.timestamp,
            expiresAt: expiresAt,
            verificationMethod: method,
            verifier: msg.sender
        });

        isVerified[user] = true;

        emit IdentityVerified(user, KYCStatus.VERIFIED, expiresAt);
    }

    /**
     * @dev Check if user is verified and not expired
     */
    function isIdentityVerified(address user) external view returns (bool) {
        if (!isVerified[user]) return false;

        VerificationRecord storage record = verifications[user];
        return record.status == KYCStatus.VERIFIED && block.timestamp <= record.expiresAt;
    }

    /**
     * @dev Get verification record
     */
    function getVerificationRecord(address user)
        external
        view
        returns (VerificationRecord memory)
    {
        return verifications[user];
    }

    /**
     * @dev Revoke verification
     */
    function revokeVerification(address user, string calldata reason)
        external
        onlyRole(ADMIN_ROLE)
    {
        isVerified[user] = false;
        verifications[user].status = KYCStatus.REJECTED;

        emit IdentityRevoked(user, reason);
    }

    /**
     * @dev Set verification expiry period
     */
    function setVerificationExpiry(uint256 newExpiry) external onlyRole(ADMIN_ROLE) {
        require(newExpiry > 0, "Invalid expiry");
        verificationExpiry = newExpiry;
        emit VerificationExpiryUpdated(newExpiry);
    }
}
