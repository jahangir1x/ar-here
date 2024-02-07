import 'package:ar_here/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/persistent_storage.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isDarkMode = ThemeProvider.IsDarkMode;
  bool isNotificationOn = true;
  bool isUsageStatisticsOn = true;

  @override
  void initState() {
    super.initState();
    isDarkMode = ThemeProvider.IsDarkMode;
    isNotificationOn = PersistentStorage.getIsNotificationOn();
    isUsageStatisticsOn = PersistentStorage.getIsUsageStatisticsOn();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 48, bottom: 0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Settings',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 40,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Dark Mode',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                Switch(
                  value: isDarkMode,
                  onChanged: (value) async {
                    Provider.of<ThemeProvider>(context, listen: false)
                        .toggleTheme();
                    await PersistentStorage.setIsDarkMode(value);
                    setState(() {
                      isDarkMode = ThemeProvider.IsDarkMode;
                    });
                  },
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Notifications',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                Switch(
                  value: isNotificationOn,
                  onChanged: (value) {
                    setState(() {
                      isNotificationOn = value;
                      PersistentStorage.setIsNotificationOn(value);
                    });
                  },
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Send Usage Statistics',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                Switch(
                  value: isUsageStatisticsOn,
                  onChanged: (value) {
                    setState(() {
                      isUsageStatisticsOn = value;
                      PersistentStorage.setIsUsageStatisticsOn(value);
                    });
                  },
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Language',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                Text(
                  'English',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Version',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                Text(
                  '1.0.0',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
