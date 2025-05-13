# Ios-dev-stockApp-assignment

A sleek and intuitive iOS cryptocurrency wallet tracker built with Swift and SwiftUI.

## Project Overview
The Crypto Wallet App allows users to monitor multiple cryptocurrency wallets and track their portfolio value across different tokens. The app uses real-time data from the Moralis API to provide up-to-date cryptocurrency prices and wallet balances.

## Features

- Multi-wallet Management: Track multiple Ethereum wallet addresses in one place
- Real-time Price Updates: Get current cryptocurrency prices and portfolio valuations
- Portfolio Overview: See your total holdings across all wallets
- Token Details: View detailed information and price charts for individual tokens
- Market View: Browse all your tokens with current prices and trends
- Token Database: Access comprehensive token information

## iOS Frameworks Used
The application leverages several iOS frameworks to deliver a modern, responsive user experience:

* **SwiftUI**: Used for building the entire user interface with a declarative approach
* **Combine**: Implemented for reactive programming and state management
* **URLSession**: Utilized for API communication with the Moralis cryptocurrency data service
* **UserDefaults**: Employed for local data persistence of wallet addresses

## Screenshots
[Include 3-4 screenshots of your app here]

## Technical Implementation

### Architecture
The app follows the MVVM (Model-View-ViewModel) architecture:

- **Models**: Define data structures for wallets, tokens, and price data
- **Views**: Present the UI and pass user actions to view models
- **ViewModels**: Handle business logic and data operations

### Key Components

- **WalletViewModel**: Manages wallet data and API communication
- **TokenPriceView**: Displays detailed token information with interactive charts
- **CombinedBalanceView**: Shows the total portfolio value and all wallets
- **MarketView**: Presents a list of all tokens with current prices
- **TokenDatabaseView**: Provides detailed token information

### Design System
The app employs a comprehensive design system:

- **ColorTheme**: Consistent color palette with dark mode support
- **Typography**: Standardized text styles for various UI elements
- **CardView**: Reusable component for content containers
- **Custom Charts**: Interactive price charts with gradient fills

### API Integration
The app integrates with the Moralis cryptocurrency API to fetch:

- Wallet token balances
- Token prices
- Price history data

### Development Process
Our team followed an iterative development approach:

1. **Planning Phase**: Defined user requirements and app architecture
2. **Design Phase**: Created wireframes and established the design system
3. **Development Phase**: Implemented core functionality iteratively
4. **Testing Phase**: Tested on multiple iOS devices and fixed issues
5. **Refinement Phase**: Enhanced UI and optimized performance

## Challenges & Solutions
During development, we encountered several challenges:

### Handling Different Token Decimals:
- Challenge: Different tokens use varying decimal places for balances
- Solution: Implemented a conversion system that adjusts based on each token's decimal specification

### Building Interactive Charts:
- Challenge: Creating responsive, visually appealing price charts
- Solution: Developed custom SwiftUI views with gesture recognition for user interaction

### API Data Synchronization:
- Challenge: Keeping wallet data updated across the app
- Solution: Implemented async/await pattern for clean API calls and UI updates

## Installation & Setup
### Requirements

- iOS 15.0+
- Xcode 13.0+
- Swift 5.5+
- A Moralis API key

## Getting Started

1. Clone the repository
- [Github repository clone](https://github.com/yourusername/crypto-wallet.git)

2. Open the Xcode project file
- open CryptoWallet.xcodeproj

3. Add your Moralis API key in MoralisAPI.swift
4. Build and run the application

Team Members

- Taahir Mahomed
- Shaiyan Khan
- Steven Yong

## Future Enhancements
Features we plan to implement in future versions:

- Token price alerts
- Historical portfolio performance tracking
- Additional wallet types (Bitcoin, etc.)
- Transaction history tracking
- Custom token management

## License
This project was created for educational purposes as part of a university assignment.

## Acknowledgements

- Moralis API for cryptocurrency data
- Apple's SwiftUI and iOS development resources


Note: This application is a demonstration project and not intended for managing real cryptocurrency investments.
