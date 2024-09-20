import 'dart:async';
import 'package:app_links/app_links.dart';
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
            // Handle unknown routes
            return MaterialPageRoute(
              builder: (context) => const UnknownRoutePage(),
            );
        }
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  '/candidate',
                  arguments: '1',
                );
              },
              child: const Text('Go to Candidate Page (Using arguments)'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/candidate/2');
              },
              child: const Text('Go to Candidate Page (Using URL)'),
            ),
            const SelectableText('''
            Launch an intent to test deep linking:

            On Android:
            adb shell am start -a android.intent.action.VIEW -d "deeplinks://candidate/123"

            On iOS Simulator:
            xcrun simctl openurl booted "deeplinks://candidate/123"

            On macOS, open your browser:
            deeplinks://candidate/123
            '''),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class CandidatePage extends StatelessWidget {
  final String candidateId;

  const CandidatePage({Key? key, required this.candidateId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Candidate Page'),
      ),
      body: Center(
        child: Text('Candidate ID: $candidateId'),
      ),
    );
  }
}

class UnknownRoutePage extends StatelessWidget {
  const UnknownRoutePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('404 - Page Not Found'),
      ),
      body: const Center(
        child: Text('The requested page does not exist.'),
      ),
    );
  }
}
