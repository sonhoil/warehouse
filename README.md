# Warehouse Management App

## Overview

The Warehouse Management App is a Flutter application designed to help users manage their warehouses efficiently. It allows users to scan QR codes to access container details, manage items within containers, and maintain a list of warehouses.

## Features

- **QR Code Scanning**: Users can scan QR codes to quickly access container information.
- **Warehouse Management**: Create, view, and manage multiple warehouses.
- **Container Management**: Add and manage containers within each warehouse.
- **Item Management**: Add, view, and manage items within each container.
- **User Authentication**: Sign in using Google for a personalized experience.

## Getting Started

To get started with the Warehouse Management App, follow these steps:

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/yourusername/warehouse.git
   cd warehouse
   ```

2. **Install Dependencies**:
   Make sure you have Flutter installed on your machine. Then run:
   ```bash
   flutter pub get
   ```

3. **Run the App**:
   You can run the app on an emulator or a physical device:
   ```bash
   flutter run
   ```

## Dependencies

The project uses the following dependencies:

- `flutter`: The Flutter SDK.
- `cupertino_icons`: Icons for iOS.
- `qr_flutter`: For generating QR codes.
- `qr_code_scanner`: For scanning QR codes.
- `shared_preferences`: For local data storage.
- `provider`: For state management.
- `uuid`: For generating unique IDs.
- `firebase_auth`: For Firebase authentication.
- `google_sign_in`: For Google sign-in functionality.


## Contributing

Contributions are welcome! If you have suggestions for improvements or new features, feel free to open an issue or submit a pull request.

## License

This project is licensed under the MIT License. See the LICENSE file for details.
