import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_api/amplify_api.dart';
import 'package:flutter/material.dart';
import 'package:fyllo/amplifyconfiguration.dart';
import 'package:fyllo/views/clusters/providers/cluster_provider.dart';
import 'package:fyllo/views/home/screens/home_screen.dart';
import 'package:fyllo/views/splash_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const Fyllo());
}

class Fyllo extends StatefulWidget {
  const Fyllo({super.key});

  @override
  State<Fyllo> createState() => _FylloState();
}

class _FylloState extends State<Fyllo> {
  @override
  void initState() {
    super.initState();
    _configureAmplify();
  }

  Future<void> _configureAmplify() async {
    try {
      final auth = AmplifyAuthCognito();
      final api = AmplifyAPI();
      await Amplify.addPlugins([auth, api]);
      await Amplify.configure(amplifyconfig);
    } on AmplifyAlreadyConfiguredException {
      safePrint(
          'Tried to reconfigure Amplify; this can occur when your app restarts on Android.');
    } on Exception catch (e) {
      safePrint('An error occurred configuring Amplify: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => ClusterProvider()),
        ],
        builder: (context, snapshot) {
          return Authenticator(
            initialStep: AuthenticatorStep.signIn,
            child: MaterialApp(
              title: 'Fýllo',
              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
                inputDecorationTheme: const InputDecorationTheme(
                  border: OutlineInputBorder(),
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                ),
                useMaterial3: true,
              ),
              builder: Authenticator.builder(),
              initialRoute: SplashScreen.routeName,
              routes: {
                SplashScreen.routeName: (context) => const SplashScreen(),
                HomeScreen.routeName: (context) => const HomeScreen(),
              },
            ),
          );
        });
  }
}
