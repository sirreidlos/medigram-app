import 'dart:async';

import 'package:flutter/material.dart';
import 'package:medigram_app/constants/dev_config.dart';
import 'package:medigram_app/navigation/layout_navbar.dart';
import 'package:medigram_app/page/login.dart';
import 'package:medigram_app/page/set_profile.dart';
import 'package:medigram_app/services/auth_service.dart';
import 'package:medigram_app/services/secure_storage.dart';
import 'package:medigram_app/services/user_service.dart';

/// The initial screen shown when the app starts.
///
/// This screen handles the app's initial loading state and authentication flow.
/// It attempts to auto-login users based on stored credentials or development mode settings.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Wait for 2 seconds to show the splash screen
    Timer(
      Duration(seconds: 2),
      () async {
        if (DevConfig.isDevelopmentMode) {
          // Development mode: auto-login with test credentials
          try {
            final response = await AuthService().login(
              DevConfig.devEmail,
              DevConfig.devPassword,
            );

            if (response.statusCode == 200) {
              if (mounted) {
                final responseDetail = await UserService().getOwnDetail();
                if (responseDetail.statusCode == 200) {
                  Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          const BottomNavigationMenu(true),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        return FadeTransition(opacity: animation, child: child);
                      },
                    ),
                  );
                } else {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => SetProfile()),
                  );
                }
              }
            } else {
              // If auto-login fails, go to login page
              if (mounted) {
                Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        const LoginPage(),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      return FadeTransition(opacity: animation, child: child);
                    },
                  ),
                );
              }
            }
          } catch (e) {
            // If there's an error, go to login page
            if (mounted) {
              Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      const LoginPage(),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    return FadeTransition(opacity: animation, child: child);
                  },
                ),
              );
            }
          }
        } else {
          // Production mode: check for existing credentials
          final sessionID = await SecureStorageService().read('session_id');
          final deviceID = await SecureStorageService().read('device_id');
          final privateKey = await SecureStorageService().read('private_key');

          if (sessionID != null && deviceID != null && privateKey != null) {
            // We have stored credentials, try to validate them
            try {
              final storedCredentials =
                  await AuthService().getStoredCredentials();
              if (storedCredentials['email'] != null &&
                  storedCredentials['password'] != null) {
                final response = await AuthService().login(
                  storedCredentials['email']!,
                  storedCredentials['password']!,
                );

                if (response.statusCode == 200) {
                  if (mounted) {
                    final responseDetail = await UserService().getOwnDetail();
                    if (responseDetail.statusCode == 200) {
                      Navigator.pushReplacement(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  const BottomNavigationMenu(true),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            return FadeTransition(
                                opacity: animation, child: child);
                          },
                        ),
                      );
                    } else {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => SetProfile()),
                      );
                    }
                  }
                } else {
                  // If validation fails, clear stored credentials and go to login page
                  await SecureStorageService().clear();
                  if (mounted) {
                    Navigator.pushReplacement(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            const LoginPage(),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          return FadeTransition(
                              opacity: animation, child: child);
                        },
                      ),
                    );
                  }
                }
              } else {
                // No stored credentials, go to login page
                await SecureStorageService().clear();
                if (mounted) {
                  Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          const LoginPage(),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        return FadeTransition(opacity: animation, child: child);
                      },
                    ),
                  );
                }
              }
            } catch (e) {
              // If there's an error, clear stored credentials and go to login page
              await SecureStorageService().clear();
              if (mounted) {
                Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        const LoginPage(),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      return FadeTransition(opacity: animation, child: child);
                    },
                  ),
                );
              }
            }
          } else {
            // No stored credentials, go to login page
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    const LoginPage(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
              ),
            );
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          'assets/icons/medigram.png',
          width: 200,
        ),
      ),
    );
  }
}
