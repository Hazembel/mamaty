import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart'; // ✅ import provider

import 'l10n/app_localizations.dart';
import 'routes/routes.dart';
import 'providers/user_provider.dart'; // ✅ import your provider

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => UserProvider()..loadUser(), // ✅ load saved user at start
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateTitle: (context) =>
          AppLocalizations.of(context)?.appTitle ?? 'Mamatyp',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,

      // 👇 Routes
      routes: {
        ...publicRoutes,
        ...privateRoutes,
      },

      // 👇 Start from Splash
      initialRoute: '/',
    );
  }
}
