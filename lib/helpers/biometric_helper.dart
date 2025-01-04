import 'dart:io';
import 'package:passwordmanager/global_dirs.dart';

class BiometricHelper {
  final LocalAuthentication auth = LocalAuthentication();


  // Check if biometric authentication is available
  Future<bool> isBiometricAvailable() async {
    try {
      bool canAuthenticate = await auth.canCheckBiometrics;
      if (Platform.isIOS) {
        // For iOS, also check if the device supports device authentication (passcode or biometrics)
        canAuthenticate = await auth.isDeviceSupported();
      }
      return canAuthenticate;
    } catch (e) {
      print('Error checking biometrics: $e');
      return false;
    }
  }

  // Authenticate user using biometrics
  Future<bool> authenticateUser() async {
    bool isAuthenticated = false;

    try {
      isAuthenticated = await auth.authenticate(
        localizedReason: 'Please authenticate to Login',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true, // Only allow biometric authentication
        ),
      );
    } catch (e) {
      print('Error during authentication: $e');
    }

    return isAuthenticated;
  }
}
