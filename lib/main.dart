import 'package:buzzzchat/splashscreen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Buzzzchat',
        theme: ThemeData(
          inputDecorationTheme: const InputDecorationTheme(
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  borderSide: BorderSide(color: Color.fromARGB(107, 0, 0, 0))),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  borderSide: BorderSide(color: Colors.black, width: 2)),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  borderSide: BorderSide(color: Colors.black, width: 2)),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                borderSide: BorderSide(color: Colors.red),
              )),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
                elevation: 5,
                backgroundColor: const Color.fromARGB(230, 245, 191, 30),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20))),
          ),
          colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromARGB(255, 92, 63, 219),
              onPrimary: const Color.fromARGB(255, 66, 165, 251),
              onSecondary: const Color.fromARGB(200, 50, 233, 44)),
          textTheme: const TextTheme(
            displayLarge: TextStyle(fontSize: 37, fontWeight: FontWeight.bold),
            displayMedium: TextStyle(fontSize: 27, fontWeight: FontWeight.w500),
            displaySmall: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
          ),
          useMaterial3: true,
        ),
        home: SplashScreen());
  }
}
