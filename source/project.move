module TalentVerify::Credentials {
    use aptos_framework::signer;
    use aptos_framework::table::{Self, Table};
    use std::string::{Self, String};
    use std::vector;

    /// Struct representing a professional credential
    struct Credential has store, drop {
        credential_name: String,
        issuer: String,
        issue_date: u64,
        expiry_date: u64,
        verified: bool,
    }

    /// Resource stored in user's account to manage their credentials
    struct UserProfile has key {
        credentials: Table<String, Credential>,
    }

    /// Function to initialize a user profile
    public entry fun initialize_profile(user: &signer) {
        let user_addr = signer::address_of(user);
        
        // Check if the user already has a profile
        if (!exists<UserProfile>(user_addr)) {
            // Create a new profile with empty credentials table
            let profile = UserProfile {
                credentials: table::new(),
            };
            move_to(user, profile);
        }
    }

    /// Function to add and verify a credential
    public entry fun verify_credential(
        verifier: &signer,
        user_addr: address,
        credential_id: String,
        credential_name: String,
        issuer: String,
        issue_date: u64,
        expiry_date: u64,
    ) acquires UserProfile {
        // Ensure the user has a profile
        assert!(exists<UserProfile>(user_addr), 1);
        
        // Only authorized verifiers should be able to call this function
        // In a real implementation, you would check if the verifier is authorized
        
        // Create the credential with verified status
        let credential = Credential {
            credential_name,
            issuer,
            issue_date,
            expiry_date,
            verified: true,
        };
        
        // Add the credential to the user's profile
        let user_profile = borrow_global_mut<UserProfile>(user_addr);
        table::upsert(&mut user_profile.credentials, credential_id, credential);
    }
}
