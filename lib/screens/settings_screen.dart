import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import 'ProfileScreen.dart';
import 'history_screen.dart';
import 'favorites_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    late final ThemeProvider themeProvider;
    late final bool isDark;
    try {
      themeProvider = Provider.of<ThemeProvider>(context);
      isDark = themeProvider.isDarkMode;
    } catch (e) {
      print('Error initializing theme provider: $e');
      isDark = true; // Default to dark mode if provider fails
      return Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Settings',
            style: TextStyle(color: Theme.of(context).colorScheme.onPrimary)),
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 0,
      ),
      body: ListView(
        children: [
          _buildSettingsTile(
            context,
            "Dark/Light Mode",
            Icons.brightness_6,
            () {
              final themeProvider =
                  Provider.of<ThemeProvider>(context, listen: false);
              themeProvider.toggleTheme();
            },
            isDark,
          ),
          _buildSettingsTile(context, "History", Icons.history, () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HistoryScreen()),
            );
          }, isDark),
          _buildSettingsTile(context, "Favorites", Icons.favorite, () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => FavoritesScreen()),
            );
          }, isDark),
          _buildSettingsTile(context, "Profile", Icons.person, () {
            // Navigate to Profile Screen
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfileScreen()),
            );
          }, isDark),
        ],
      ),
    );
  }

  Widget _buildSettingsTile(BuildContext context, String title, IconData icon,
      VoidCallback onTap, bool isDark) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: onTap,
    );
  }
}
