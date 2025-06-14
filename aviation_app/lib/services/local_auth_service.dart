import 'package:local_auth/local_auth.dart';

// class LocalAuthService {
//   final LocalAuthentication _localAuth = LocalAuthentication();
//   Future<bool> authenticateWithBiometrics() async {
//     bool isAuthenticated = false;
//     try {
//       isAuthenticated = await _localAuth.authenticate(
//         localizedReason: 'Please authenticate to access this feature',
//         options: const AuthenticationOptions(
//           useErrorDialogs: true,
//           stickyAuth: true,
//         ),
//       );
//     } on PlatformException catch (e) {
//       print(e);

//       // if (e.code == auth_error.notAvailable) {
//       //   // Handle not available error
//       // } else if (e.code == auth_error.passcodeNotSet) {
//       //   // Handle passcode not set error
//       // } else if (e.code == auth_error.notEnrolled) {
//       //   // Handle not enrolled error
//       // } else if (e.code == auth_error.lockedOut) {
//       //   // Handle locked out error
//       // } else {
//       //   // Handle other errors
//       // }
//     }
//     return isAuthenticated;
//   }
// }



class LocalAuthService {
  final LocalAuthentication _localAuth = LocalAuthentication();

  Future<bool> canAuthenticateWithBiometrics() async {
    try {
      // Check if biometric hardware is available and at least one biometric is enrolled
      bool canCheckBiometrics = await _localAuth.canCheckBiometrics;
      bool isDeviceSupported = await _localAuth.isDeviceSupported();
      List<BiometricType> availableBiometrics = await _localAuth.getAvailableBiometrics();
      return canCheckBiometrics && isDeviceSupported && availableBiometrics.isNotEmpty;
    } catch (e) {
      print("Error checking biometrics: $e");
      return false;
    }
  }

  Future<bool> authenticateWithBiometrics() async {
    try {
      return await _localAuth.authenticate(
        localizedReason: 'Please authenticate to clock in/out',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );
    } catch (e) {
      print("Error during biometric authentication: $e");
      return false;
    }
  }
}