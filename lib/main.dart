import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'test2/layout_cubit.dart';
import 'test2/layout_editor_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final sampleChildren = [
      _buildCard(
        title: 'Flutter',
        icon: Icons.flutter_dash,
        color: Colors.blue,
        description: 'Build beautiful cross-platform apps',
      ),
      _buildCard(
        title: 'Dart',
        icon: Icons.code,
        color: Colors.cyan,
        description: 'Fast and productive language',
      ),
      _buildCard(
        title: 'BLoC Pattern',
        icon: Icons.architecture,
        color: Colors.purple,
        description: 'State management solution',
      ),
      _buildCard(
        title: 'Responsive',
        icon: Icons.phone_android,
        color: Colors.green,
        description: 'Adaptive UI for all screens',
      ),
      _buildCard(
        title: 'Performance',
        icon: Icons.speed,
        color: Colors.orange,
        description: 'Optimized and smooth experience',
      ),
      _buildCard(
        title: 'Open Source',
        icon: Icons.favorite,
        color: Colors.red,
        description: 'Community-driven development',
      ),
    ];

    return MaterialApp(
      title: 'Layout Editor',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(title: const Text('Layout Editor (Cubit)')),
        body: BlocProvider(
          create: (context) => LayoutCubit(),
          child: LayoutEditorPage(
            children: sampleChildren,
            onItemRemoved: (value) {},
          ),
        ),
      ),
    );
  }

  static Widget _buildCard({
    required String title,
    required IconData icon,
    required Color color,
    required String description,
  }) {
    return Card(
      elevation: 4,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [color.withOpacity(0.8), color.withOpacity(0.3)],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 40, color: color),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: const TextStyle(fontSize: 13, color: Colors.black54),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
