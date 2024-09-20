import 'package:deeplinks_flutter/candiate_page.dart';
import 'package:deeplinks_flutter/home_page.dart';
import 'package:deeplinks_flutter/unknown_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/home',
      onGenerateRoute: (settings) {
        print("=======================");
        print(settings.name);
        print("======================");
        switch (settings.name) {
          case '/home':
            return MaterialPageRoute(
              builder: (context) =>
                  const MyHomePage(title: 'Flutter Demo Home Page'),
            );
          case '/candidate':
            final candidateId = settings.arguments as String?;
            return MaterialPageRoute(
              builder: (context) =>
                  CandidatePage(candidateId: candidateId ?? 'Not provided'),
            );
          default:
            if (settings.name?.startsWith('/candidate/') ?? false) {
              final candidateId = settings.name?.split('/').last;
              return MaterialPageRoute(
                builder: (context) =>
                    CandidatePage(candidateId: candidateId ?? 'Not provided'),
              );
            }
            // Handle unknown routes
            return MaterialPageRoute(
              builder: (context) => const UnknownRoutePage(),
            );
        }
      },
    );
  }
}
