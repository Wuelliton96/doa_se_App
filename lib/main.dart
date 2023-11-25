import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/AuthenticationWrapper.dart';
import 'services/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(Doase());
}

class Doase extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Doa-se',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: AuthenticationWrapper(),
    );
  }
}
