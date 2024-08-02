import 'package:ext_fingerprint/success/success_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
  static const platform = MethodChannel('sample.api.call');

  String _apiResponse = '';

  Future<void> _getAPIResponse() async {
    String apiResponse;
    try {
      final result = await platform.invokeMethod('getApiResponse');
      apiResponse = 'Title from API Response: $result.';
    } on PlatformException catch (e) {
      apiResponse = "Failed to get API Response: '${e.message}'.";
    }

    setState(() {
      _apiResponse = apiResponse;
    });
    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SuccessScreen(percentage: _apiResponse),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: _getAPIResponse,
              child: const Text('Get API Response'),
            ),
          ],
        ),
      ),
    );
  }
}
