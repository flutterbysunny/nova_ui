import 'package:flutter/material.dart';
import 'package:nova_ui/nova_ui.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nova UI Demo',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Nova UI Demo'),
        ),
        body: Center(
          child: Column(
            children: [
              NovaContainer(
                padding: const EdgeInsets.all(20),
                color: Colors.blue,
                borderRadius: BorderRadius.circular(16),
                child: const Text(
                  'Hello Nova UI',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
              SizedBox(height: 10,),
              NovaTextField(
                hintText: 'Email',
                prefixIcon: const Icon(Icons.email),
              ),
              SizedBox(height: 10,),
              NovaButton(
                text: 'Login',
                onPressed: () {
                  debugPrint('Clicked');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}