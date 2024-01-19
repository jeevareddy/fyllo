import 'package:flutter/material.dart';
import 'package:fyllo/widgets/custom_loading_indicator.dart';

class SplashScreen extends StatefulWidget {
  static String routeName = "/";
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState(){
    super.initState();
    Future.delayed(const Duration(seconds: 3), (){
      Navigator.pushReplacementNamed(context, "/home");
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,            
            children: [
              Row(
                children: [
                  Hero(
                    tag: "logo",
                    child: Image.asset(
                      "assets/images/logo.png",
                      width: MediaQuery.of(context).size.width * 0.32,
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Flexible(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Welcome to Fýllo, your green haven! 🌿",
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16.0),
                        Text(
                          "Let's build a sustainable community together.",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            
            const SizedBox(height: 16.0,),

            const CustomLoadingIndicator()
            ],
          ),
        ),
      ),
    );
  }
}
