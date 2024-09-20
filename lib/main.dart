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

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

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
                  arguments: '1', // Passing a dummy candidate ID
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

  const CandidatePage({super.key, required this.candidateId});

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
  const UnknownRoutePage({super.key});

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
