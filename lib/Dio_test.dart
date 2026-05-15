import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class DioTestPage extends StatefulWidget {
  const DioTestPage({super.key});

  @override
  State<DioTestPage> createState() => _DioTestPageState();
}

class _DioTestPageState extends State<DioTestPage> {
  String _responseText = 'Press button to test Dio';

  Future<void> testDio() async {
    final dio = Dio();

    // Global interceptor to inject X-Platform
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        options.headers['X-Platform'] = 'bizzzinda';
        print("Headers being sent: ${options.headers}");
        return handler.next(options);
      },
    ));

    // Optional: LogInterceptor for full request/response logging
    dio.interceptors.add(LogInterceptor(
      requestHeader: true,
      responseHeader: true,
      requestBody: true,
      responseBody: true,
    ));

    try {
      final response = await dio.get('https://your-backend-api.com/test');
      print('Response data: ${response.data}');
      print('Request headers (from response object): ${response.requestOptions.headers}');

      setState(() {
        _responseText = response.data.toString();
      });
    } catch (e) {
      print('Error: $e');
      setState(() {
        _responseText = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dio Test Page')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: testDio,
              child: const Text('Test Dio Request'),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Text(_responseText),
              ),
            ),
          ],
        ),
      ),
    );
  }
}