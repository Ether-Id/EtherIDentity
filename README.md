# EtherIdentity Whitepaper

## Overview

**EtherIdentity** is a decentralized, privacy-preserving KYC (Know Your Customer) verification system built on the Ethereum blockchain. It combines cryptographic techniques, NFT metadata, and AI-powered verification to allow users to create a secure digital identity that can be used across multiple platforms—especially centralized and decentralized exchanges—without ever sharing sensitive personal data.

## Vision & Mission

Our mission is to give users control over their identity while enabling compliance with regulatory standards. EtherIdentity protects user data by:
- Encrypting sensitive information with the user’s private key.
- Storing only the cryptographic hash (kycHash) on-chain via NFT.
- Ensuring bourses and other services can verify identity without seeing the actual user data.

## Key Features

### 1. Private Key & Encrypted Identity JSON
Each user creates a new identity via the EtherIdentity app, which generates a unique private key. This key is used to encrypt a JSON file containing:
- Name, Surname, National ID, Address
- Email, Phone number
- Photos: front/back of ID, selfie with ID
- Liveness check score

This JSON is encrypted locally using AES (CBC + PKCS7), and only the encrypted version remains on the user's device.

### 2. AI Verification Layer
Before finalizing the KYC process, the app uses AI (simulated in MVP) to:
- Verify document authenticity
- Perform liveness detection
- Validate input data accuracy

Once passed, a canonical version of the decrypted JSON is hashed (SHA-256), then combined with the private key and re-hashed to produce the final **kycHash**.

### 3. NFT Minting
The app submits the following to EtherIdentity’s backend:
- `kycHash`
- `privateKey`

The backend stores this data securely and mints an NFT (on testnet for MVP), writing to its metadata:
- `kycHash`
- Verification confidence (e.g., 96%)
- Timestamp

The encrypted JSON is **never uploaded**, ensuring full user-side data control.

### 4. Secure Re-Entry with PIN or Biometrics
After registering, users can access their identity using:
- A PIN they set during setup
- Optional biometric authentication

Their encrypted JSON and private key are locally stored via `shared_preferences`.

### 5. Identity Import & Recovery
Users can re-import their identity using:
- Encrypted JSON file
- Their 64-char private key

The app decrypts and re-verifies the kycHash. If it matches the NFT metadata and the server record, access is granted.

### 6. Exchange Integration (CEX/DEX Usage)
When a user wants to KYC for an exchange:
- They share the encrypted JSON file + kycHash
- The exchange then:
  - Trusts the on-chain NFT metadata if the hash matches
  - Stores the encrypted JSON for compliance
  - Cannot view personal data unless they obtain the private key from EtherIdentity

### 7. Legal Access Protocol
If legally compelled:
- The exchange requests the private key from EtherIdentity
- EtherIdentity verifies court documentation
- If legitimate, the private key is released
- Only then can the JSON be decrypted and the identity revealed

## Security Principles
- AES-256 encryption with unique IVs per user
- Hashing with SHA-256 for consistency
- No sensitive data leaves the device
- NFT metadata contains only non-reversible hash

## Tech Stack
- Flutter (UI)
- Dart (Client logic)
- AES Encryption via `encrypt`
- File selection with `file_picker`
- IPFS or testnet NFT minting (via backend)
- SharedPreferences (storage)

## Current Status
- ✅ MVP Complete
- ✅ NFT Metadata Functional
- ✅ PIN Entry & Local Access Working
- ✅ Import/Export JSON Supported

## Roadmap
- Q2 2025: Mainnet deployment & bug bounties
- Q3 2025: CEX integration API
- Q4 2025: zkKYC implementation
- 2026: DAO launch & compliance standards

## Contact
- Twitter: https://x.com/Ether_IDentity
- E posta: e97461060@gmail.com

