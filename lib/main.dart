import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:deeplinks/pages/candidate.dart';
import 'package:deeplinks/pages/home.dart';
import 'package:deeplinks/pages/unknown.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _navigatorKey = GlobalKey<NavigatorState>();
  late AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSubscription;

  @override
  void initState() {
    super.initState();
    initDeepLinks();
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();
    super.dispose();
  }

  Future<void> initDeepLinks() async {
    _appLinks = AppLinks();

    // Check initial link if app was launched from dead
    // the link should be of type deeplinks://link/{path to the page}
    final appLink = await _appLinks.getInitialLinkString();
    if (appLink != null) {
      print('getInitialAppLink: $appLink');
      openAppLink(Uri.parse(appLink));
    }

    // Handle app links while app is in memory
    _linkSubscription = _appLinks.uriLinkStream.listen((Uri uri) {
      print('onAppLink: $uri');
      openAppLink(uri);
    });
  }

  void openAppLink(Uri uri) {
    if (uri.scheme == 'deeplinks') {
      final path = uri.path;
      print('Handling deep link: $path');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _navigatorKey.currentState?.pushNamed(path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navigatorKey,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/home',
      onGenerateRoute: (settings) {
        print('Generating route for: ${settings.name}');
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
            return MaterialPageRoute(
              builder: (context) => const UnknownRoutePage(),
            );
        }
      },
    );
  }
}
