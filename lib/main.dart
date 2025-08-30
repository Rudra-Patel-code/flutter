import 'package:flutter/material.dart';
import 'package:myapp/providers/task_providers.dart';
import 'package:myapp/screens/home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

// entry point of the app
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // makeing sure that firebase is initialized
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // setting up provider and providing the context
    return ChangeNotifierProvider(
      create: (context) => TaskProvider(),
      child: const MaterialApp(home: Home_Page()),
    );
  }
}
