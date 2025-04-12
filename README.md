EtherIdentity
EtherIdentity is a decentralized KYC (Know Your Customer) verification platform. It securely stores, verifies, and shares user identity data, ensuring that only authorized parties can access it. This application uses Ethereum Blockchain technology to perform identity verification in a decentralized manner.

Table of Contents
Project Overview

User Features

Exchange Features

Investor Features

Technical Architecture & Technologies

Setup and Run

License

Project Overview
EtherIdentity is a decentralized platform that allows users to securely store and verify their identity data. Users can encrypt their identity data and store it on the Ethereum Blockchain, where it can only be accessed using a private key. This system protects against identity fraud and enhances security for both users and exchanges.

User Features
Create a New Identity: Users can sign up by entering their identity details (first name, last name, ID number, address, phone number, etc.) and upload identity card front/back images and selfies.

Private Key and Encryption: Users can securely encrypt their identity data, and the data can only be accessed with the corresponding private key. Identity information is encrypted using the AES encryption algorithm and protected with the SHA-256 hashing algorithm.

NFT Minting: Users mint their encrypted identity information as an NFT (Non-Fungible Token) on the Ethereum Blockchain. This NFT ensures that only the authorized person can access the identity verification data.

Identity Verification and Login: Users can log in using either a PIN or biometric authentication (fingerprint/face recognition) for secure access to their account.

Exchange Features
Identity Data Verification: Exchanges can use EtherIdentity to verify the user's identity. Exchanges cannot access the actual identity data; they can only verify the kycHash.

Privacy and Legal Compliance: User identity data is stored only in an encrypted form. In the event of legal issues, the private key can be requested through a court order.

Investor Features
Transparency: Investors can use EtherIdentity to ensure the security and authenticity of transactions made on exchanges.

Identity Security: EtherIdentity ensures that user identities are securely encrypted, protecting against fraud and unauthorized access.

Technical Architecture & Technologies
Ethereum Blockchain: Ethereum Blockchain is used for identity verification processes. Identity data is encrypted and minted as an NFT, then written to the Ethereum network.

AES-256: User information is encrypted using the AES encryption algorithm.

SHA-256: Identity data is hashed and written to the Blockchain.

Flutter: The mobile app is developed using Flutter, making it compatible with both Android and iOS platforms.

Shared Preferences: User data is securely stored on the device.

Lottie Animations: Animations are used to enhance the user experience within the app.

Setup and Run
Prerequisites
Flutter SDK

Android Studio or Xcode (for iOS)

Dart SDK

Project Setup
Clone this repository:

bash
Kopyala
git clone https://github.com/Ether-Id/EtherIDentity.git
Navigate to the project directory:

bash
Kopyala
cd EtherIDentity
Install dependencies:

bash
Kopyala
flutter pub get
Start the Android Emulator (from Android Studio or terminal):

bash
Kopyala
flutter emulators --launch <emulator_id>
Run the app:

bash
Kopyala
flutter run
License
This project is licensed under the MIT License. For more details, please refer to the LICENSE file.
