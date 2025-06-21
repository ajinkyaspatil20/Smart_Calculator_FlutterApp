import 'package:flutter/material.dart';
import 'package:mpl_lab/utils/themes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'firebase_options.dart';
import 'providers/theme_provider.dart';
import 'providers/favorites_provider.dart';
import 'providers/user_provider.dart';
import 'utils/themes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase with platform-specific options
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Fetch name from Firestore
  //String? fetchedName = await fetchNameFromFirestore();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ChangeNotifierProvider(create: (_) => FavoritesProvider()),
      ChangeNotifierProvider(create: (_) => UserProvider()),
    ],
    child: MyApp(),
  ));
}

// Function to fetch 'name' from Firestore's 'test' collection

class MyApp extends StatelessWidget {
  //final String? fetchedName;
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    //print(fetchedName); // Still printing for debugging purposes

    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Advanced Calculator',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
        home: HomeScreen());
  }
}
