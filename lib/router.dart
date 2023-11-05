import 'package:ar_flutter_plugin_example/screens/account_screen.dart';
import 'package:ar_flutter_plugin_example/screens/home_screen.dart';
import 'package:ar_flutter_plugin_example/screens/qr_scan_screen.dart';
import 'package:ar_flutter_plugin_example/screens/settings_screen.dart';
import 'package:ar_flutter_plugin_example/screens/upload_screen.dart';
import 'package:flutter/material.dart';

Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case SettingsScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (context) => SettingsScreen(),
      );
    case UploadScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (context) => UploadScreen(),
      );
    case HomeScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (context) => HomeScreen(),
      );
    case QrScanScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (context) => QrScanScreen(),
      );
    case AccountScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (context) => AccountScreen(),
      );
    default:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (context) => Scaffold(
          body: Center(
            child: Text('No route defined for ${routeSettings.name}'),
          ),
        ),
      );
  }
}