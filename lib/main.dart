import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app/pages/widgets/auth_widget.dart';
import 'app/pages/home/admin_home.dart';
import 'app/pages/auth/sign_in_page.dart';
  
void main() async {
  const supabaseUrl = 'https://cemjfessszigeoeuwzvf.supabase.co';
  const supabaseKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImNlbWpmZXNzc3ppZ2VvZXV3enZmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTA3NjI2NjcsImV4cCI6MjA2NjMzODY2N30.uL6imFD_LDObtlWK49s06kHpquspoGLy-Nfa0FL1MVA";
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseKey);
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        colorScheme: ColorScheme.fromSeed(
          primary: Colors.orange,
          seedColor: Colors.orange,
        ),
      ),
      home: AuthWidget(
        signedInBuilder: (BuildContext context) {
          return AdminHome();
        },
        nonSignedInBuilder: (BuildContext context) {
          return const SignInPage();
        },
        adminSignedInBuilder: (BuildContext context) {
          return AdminHome();
        },
      ),
    );
  }
}
