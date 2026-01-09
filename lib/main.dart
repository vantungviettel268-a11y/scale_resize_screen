import 'package:flutter/material.dart';
import 'package:flutter_application_1/resize_drag_screen/resize_drag_screen.dart';

// Giả sử các package này tồn tại trong dự án của bạn
// import 'package:tendoo_components/tendoo_components.dart';
// import 'package:tendoo_shared/tendoo_shared.dart';
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
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    const ResizeDragScreen(), // Điều hướng đến ResizeDragScreen
              ),
            );
          },
          child: const Text('Go to Resize Drag Screen'),
        ),
      ),
    );
  }
}
