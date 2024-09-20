import 'package:flutter/material.dart';

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
