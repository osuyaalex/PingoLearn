import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:pune_india_app/Network/network.dart';
import 'package:pune_india_app/providers/text_field_providers.dart';

import 'auth/log_in.dart';
import 'home/home.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  //await FirebaseRemoteConfig.instance.fetchAndActivate();
  await Network().initializeRemoteConfig();
  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_){
          return SignInDetailsProvider();
        })
      ],
      child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xff467dce)),
        useMaterial3: true,
      ),
      home:FutureBuilder(
        future: Future.delayed(const Duration(milliseconds: 500)), // Simulate a delay
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold();
          } else {
            return StreamBuilder<User?>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Scaffold();
                } else if (snapshot.hasData) {
                  return const Home();
                } else {
                  return const LogInPage();
                }
              },
            );
          }
        },
      ),
    );
  }
}
