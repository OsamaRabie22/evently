import 'package:easy_localization/easy_localization.dart';
import 'package:evently_1/providers/theme_provider.dart';
import 'package:evently_1/screens/add_event/add_event_screen.dart';
import 'package:evently_1/screens/add_event/edit_event_screen.dart';
import 'package:evently_1/screens/add_event/event_details_screen.dart';
import 'package:evently_1/screens/auth/login_screen.dart';
import 'package:evently_1/screens/auth/signup_screen.dart';
import 'package:evently_1/screens/home/home_screen.dart';
import 'package:evently_1/screens/introduction_screens/onboarding_pages_screen.dart';
import 'package:evently_1/screens/onbording_screen/onbording_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'core/my_theme.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en', 'US'), Locale('ar', 'EG')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en', 'US'),
      child: ChangeNotifierProvider(
        create: (_) => ThemeProvider(),
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final myProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      debugShowCheckedModeBanner: false,
      theme: MyThemeData.lightTheme,
      darkTheme: MyThemeData.darkTheme,
      themeMode: myProvider.themeMode,
      // ── Auth Gate ──────────────────────────────────────────
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          if (snapshot.hasData) {
            return HomeScreen();
          }
          return LoginScreen();
        },
      ),
      routes: {
        OnbordingScreen.routeName: (_) => OnbordingScreen(),
        LoginScreen.routeName: (_) => LoginScreen(),
        SignUpScreen.routeName: (_) => SignUpScreen(),
        OnboardingPagesScreen.routeName: (_) => OnboardingPagesScreen(),
        HomeScreen.routeName: (_) => HomeScreen(),
        AddEventScreen.routeName: (_) => const AddEventScreen(),
        EventDetailsScreen.routeName: (_) => const EventDetailsScreen(),
        EditEventScreen.routeName: (_) => const EditEventScreen(),
      },
    );
  }
}