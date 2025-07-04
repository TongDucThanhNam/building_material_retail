import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'app/widgets/auth_widget.dart';
import 'app/pages/home/admin_home.dart';
import 'app/pages/auth/sign_in_page.dart';
  
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();

  final supabaseUrl = dotenv.env['PROJECT_URL'] ?? "";
  final supabaseKey = dotenv.env['ANON_KEY'] ?? "";

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
      debugShowCheckedModeBanner: false, // Hide debug banner
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
