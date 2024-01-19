import 'package:flutter/material.dart';
import 'package:fyllo/views/clusters/providers/cluster_provider.dart';
import 'package:fyllo/views/home/screens/home_screen.dart';
import 'package:fyllo/views/splash_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ClusterProvider()),
      ],
      builder: (context, snapshot) {
        return MaterialApp(
          title: 'Fýllo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
            inputDecorationTheme: const InputDecorationTheme(
              border: OutlineInputBorder(),
              floatingLabelBehavior: FloatingLabelBehavior.never,
            ),
            useMaterial3: true,
          ),
          initialRoute: SplashScreen.routeName,
          routes: {
            SplashScreen.routeName: (context) => const SplashScreen(),
            HomeScreen.routeName: (context) => const HomeScreen(),
          },
        );
      }
    );
  }
}
