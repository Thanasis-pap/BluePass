# BluePass Password Manager

A secure and user-friendly **Password Manager** application that allows users to store and manage their passwords and card information safely. Each user's data is encrypted using AES encryption to ensure that sensitive information like passwords and card details are protected.

## Features

- **Password Management**: Store, edit, and delete your passwords securely.
- **Card Management**: Add, edit, and delete your card information.
- **Encryption**: All sensitive data such as passwords and card information are encrypted using AES encryption.
- **Biometric Authentication**: Use biometric authentication to secure your data.
- **Data Export**: Export your data (passwords and cards) to a single encrypted `.db` file stored in the Downloads folder.
- **Favorites**: Mark passwords and cards as favorites for quick access.

## Screenshots

Add your screenshots here to showcase the app's UI and features.

---

## Installation

1. **Clone the repository**:
    ```bash
    git clone https://github.com/your-username/password-manager.git
    ```
   
2. **Navigate to the project directory**:
    ```bash
    cd password-manager
    ```

3. **Install dependencies**:
    Ensure you have Flutter installed. If not, install Flutter from [here](https://flutter.dev/docs/get-started/install).

    Then run:
    ```bash
    flutter pub get
    ```

4. **Run the app**:
    Connect your mobile device or start an emulator and run:
    ```bash
    flutter run
    ```

---

## Usage

### Adding Passwords
- Navigate to the password section, and tap the **Add Password** button.
- Enter the relevant details such as the account name, username, password, and optional notes.

### Managing Cards
- Go to the cards section, and tap the **Add Card** button.
- Add card details such as cardholder name, card number, expiration date, and CVV.

### Exporting Data
- Navigate to the settings page and select **Export Data**.
- Your passwords and cards are exported as an encrypted `.db` file to your device's Downloads folder.

---

## Security

- **Encryption**: The app uses AES encryption to protect all sensitive information stored in the database.
- **Biometric Authentication**: Users can enable biometric login for additional security.

---

## Project Structure

```bash
lib/
├── main.dart               # The entry point of the application
├── models/                 # Contains data models (Password, Card)
├── services/               # Contains encryption and database services
├── screens/                # All the UI screens
├── global_dirs.dart        # Contains the global directories for storage
├── helpers/                # AES encryption helpers
└── widgets/                # Custom reusable widgets
