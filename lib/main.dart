// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:mindaigle/core/config/api_config.dart';
// import 'package:mindaigle/features/authentication/views/login_page.dart';
// import 'package:mindaigle/features/authentication/views/signup_page.dart';
// import 'package:mindaigle/features/authentication/views/forgot_password_page.dart';
// import 'package:mindaigle/core/theme/theme.dart';
// import 'package:mindaigle/features/dashboard/views/dashboard_page.dart';
// import 'package:mindaigle/features/profile/views/profile_page.dart';
// import 'package:mindaigle/features/connections/views/connections_page.dart';
// import 'package:mindaigle/features/connections/controllers/connections_controller.dart';
// import 'package:mindaigle/features/profile/controllers/profile_controller.dart';
// import 'package:mindaigle/common/widgets/nav_bar.dart';
// import 'package:mindaigle/features/wearable_device/views/werable_device_page.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   // Initialize emulator check before checking login status
//   await ApiConfig.initializeEmulatorCheck();

//   // Check if the user is logged in
//   final isLoggedIn = await isUserLoggedIn();

//   runApp(MyApp(isLoggedIn: isLoggedIn));
// }

// class MyApp extends StatelessWidget {
//   final bool isLoggedIn;

//   const MyApp({required this.isLoggedIn, super.key});

//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//       title: 'Mindaigle',
//       theme: AppTheme.lightTheme.copyWith(
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),
//       darkTheme: AppTheme.darkTheme.copyWith(
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),
//       themeMode: ThemeMode.system,
//       // Set initial route based on whether the user is logged in
//       initialRoute: isLoggedIn ? '/home' : '/login',
//       initialBinding: BindingsBuilder(() {
//         Get.put(ConnectionsController());
//         Get.put(ProfileController());
//       }),
//       getPages: [
//         GetPage(name: '/', page: () => const LoginPage()),
//         GetPage(name: '/login', page: () => const LoginPage()),
//         GetPage(name: '/signup', page: () => const SignupPage()),
//         GetPage(
//             name: '/forgot-password', page: () => const ForgotPasswordPage()),
//         GetPage(name: '/dashboard', page: () => DashboardPage()),
//         GetPage(name: '/profile', page: () => const ProfilePage()),
//         GetPage(name: '/connections', page: () => const ConnectionsPage()),
//         GetPage(name: '/home', page: () => const NavBar()),
//         GetPage(
//             name: '/wearable-device', page: () => const WearableDevicePage()),
//       ],
//     );
//   }
// }

// // Check if the user is logged in
// Future<bool> isUserLoggedIn() async {
//   const secureStorage = FlutterSecureStorage();
//   String? uid = await secureStorage.read(key: 'uid');
//   return uid != null;
//}
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindaigle/features/authentication/views/login_page.dart';
import 'package:mindaigle/features/authentication/views/signup_page.dart';
import 'package:mindaigle/features/authentication/views/forgot_password_page.dart';
import 'package:mindaigle/core/theme/theme.dart';
import 'package:mindaigle/features/dashboard/views/dashboard_page.dart';
import 'package:mindaigle/features/debug/connection_test_page.dart';
import 'package:mindaigle/features/profile/views/profile_page.dart';
import 'package:mindaigle/features/connections/views/connections_page.dart';
import 'package:mindaigle/features/connections/controllers/connections_controller.dart';
import 'package:mindaigle/features/profile/controllers/profile_controller.dart';
import 'package:mindaigle/common/widgets/nav_bar.dart';
import 'package:mindaigle/features/wearable_device/views/werable_device_page.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:mindaigle/core/config/api_config.dart';

class ErrorScreen extends StatelessWidget {
  final String error;

  const ErrorScreen({Key? key, required this.error}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.red),
                const SizedBox(height: 16),
                const Text('Application Error',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(error, textAlign: TextAlign.center),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    // Restart app
                    Get.offAll(() => const ConnectionTestPage());
                  },
                  child: const Text('Test Connection'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    print('\n=== Initializing App ===');
    await ApiConfig.initializeEmulatorCheck();

    print(
        'Device Type: ${ApiConfig.isEmulator ? "Emulator" : "Physical Device"}');
    print('Server URL: ${ApiConfig.getBaseUrl()}');

    bool isConnected = false;
    try {
      isConnected = await ApiConfig.testConnection();
      print('Initial Connection Test: ${isConnected ? "SUCCESS" : "FAILED"}');
    } catch (e) {
      print('Connection Test Error: $e');
    }

    bool isLoggedIn = false;
    try {
      isLoggedIn = await isUserLoggedIn();
      print('User Login Status: ${isLoggedIn ? "Logged In" : "Not Logged In"}');
    } catch (e) {
      print('Login Check Error: $e');
    }

    Get.put(NetworkErrorHandler());

    runApp(MyApp(isLoggedIn: isLoggedIn));

    // Navigate to test page after brief delay
    await Future.delayed(const Duration(seconds: 2));
    Get.toNamed('/test-connection');
  } catch (e) {
    print('Fatal Initialization Error: $e');
    runApp(ErrorScreen(error: e.toString()));
  }
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({required this.isLoggedIn, super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Mindaigle',
      theme: AppTheme.lightTheme.copyWith(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      darkTheme: AppTheme.darkTheme.copyWith(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      themeMode: ThemeMode.system,
      home: isLoggedIn ? const NavBar() : const LoginPage(),
      initialRoute: null,
      initialBinding: BindingsBuilder(() {
        Get.put(ConnectionsController());
        Get.put(ProfileController());
      }),
      getPages: [
        GetPage(name: '/login', page: () => const LoginPage()),
        GetPage(name: '/signup', page: () => const SignupPage()),
        GetPage(
            name: '/forgot-password', page: () => const ForgotPasswordPage()),
        GetPage(name: '/dashboard', page: () => DashboardPage()),
        GetPage(name: '/profile', page: () => const ProfilePage()),
        GetPage(name: '/connections', page: () => const ConnectionsPage()),
        GetPage(name: '/home', page: () => const NavBar()),
        GetPage(
            name: '/wearable-device', page: () => const WearableDevicePage()),
        GetPage(
            name: '/test-connection', page: () => const ConnectionTestPage()),
      ],
      builder: (context, child) {
        return MaterialApp(
          home: child ?? const Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}

class NetworkErrorHandler extends GetxController {
  void handleError(dynamic error) {
    String message;
    if (error.toString().contains('SocketException') ||
        error.toString().contains('Connection failed')) {
      message = 'Connection Error:\n\n'
          '• Check if the server is running\n'
          '• Verify USB debugging is enabled\n'
          '• Ensure ADB reverse is set up (adb reverse tcp:5001 tcp:5001)\n'
          '• Confirm device and computer are on the same network';
    } else {
      message =
          'Error: ${error.toString()}\nPlease try again or contact support.';
    }

    Get.snackbar(
      'Connection Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red.shade700,
      colorText: Colors.white,
      duration: const Duration(seconds: 7),
      isDismissible: true,
      icon: const Icon(Icons.error_outline, color: Colors.white),
      margin: const EdgeInsets.all(8),
    );
  }
}

Future<bool> isUserLoggedIn() async {
  const secureStorage = FlutterSecureStorage();
  String? uid = await secureStorage.read(key: 'uid');
  return uid != null;
}
