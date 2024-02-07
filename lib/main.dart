import 'package:ar_here/screens/account_screen.dart';
import 'package:ar_here/screens/home_screen.dart';
import 'package:ar_here/screens/qr_scan_screen.dart';
import 'package:ar_here/screens/settings_screen.dart';
import 'package:ar_here/screens/test_download_screen.dart';
import 'package:ar_here/screens/test_screen.dart';
import 'package:ar_here/screens/upload_screen.dart';
import 'package:ar_here/theme/theme_provider.dart';
import 'package:ar_here/utils/persistent_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:ar_flutter_plugin/ar_flutter_plugin.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';

import 'examples/debugoptionsexample.dart';
import 'examples/localandwebobjectsexample.dart';
import 'examples/objectgesturesexample.dart';
import 'examples/objectsonplanesexample.dart';
import 'examples/screenshotexample.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PersistentStorage.init();
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final PersistentTabController _controller =
      PersistentTabController(initialIndex: 2);
  bool isDarkMode =
      SchedulerBinding.instance!.window.platformBrightness == Brightness.dark;

  @override
  Widget build(BuildContext context) {
    Provider.of<ThemeProvider>(context).loadTheme();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DemoSpace',
      theme: Provider.of<ThemeProvider>(context).themeData,
      home: drawBottomTabBar(context),
    );
  }

  List<Widget> _buildScreens() {
    return [
      HomeScreen(),
      UploadScreen(),
      SettingsScreen(),
      QrScanScreen(),
      AccountScreen(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(Icons.settings),
        title: ("Settings"),
        activeColorPrimary: Colors.blue,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.upload),
        title: ("Upload"),
        activeColorPrimary: Colors.blue,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.home),
        title: ("Home"),
        activeColorPrimary: Colors.blue,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.qr_code_scanner),
        title: ("QR"),
        activeColorPrimary: Colors.blue,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.account_circle),
        title: ("Account"),
        activeColorPrimary: Colors.blue,
        inactiveColorPrimary: Colors.grey,
      )
    ];
  }

  drawBottomTabBar(BuildContext context) {
    return PersistentTabView(
      context,
      controller: _controller,
      screens: _buildScreens(),
      items: _navBarsItems(),
      confineInSafeArea: true,
      backgroundColor:
          ThemeProvider.IsDarkMode == true ? Colors.black : Colors.white,
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: true,
      stateManagement: true,
      hideNavigationBarWhenKeyboardShows: true,
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(10.0),
        colorBehindNavBar:
            ThemeProvider.IsDarkMode == true ? Colors.black : Colors.white,
      ),
      popAllScreensOnTapOfSelectedTab: true,
      popActionScreens: PopActionScreensType.all,
      itemAnimationProperties: ItemAnimationProperties(
        // Navigation Bar's items animation properties.
        duration: Duration(milliseconds: 200),
        curve: Curves.ease,
      ),
      screenTransitionAnimation: ScreenTransitionAnimation(
        // Screen transition animation on change of selected tab.
        animateTabTransition: true,
        curve: Curves.ease,
        duration: Duration(milliseconds: 200),
      ),
      navBarStyle:
          NavBarStyle.style1, // Choose the nav bar style with this property.
    );
  }
}
