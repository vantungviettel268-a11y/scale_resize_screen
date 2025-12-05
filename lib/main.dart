import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'test2/layout_cubit.dart';
import 'test2/layout_editor_page.dart';

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
      home: BlocProvider(
        create: (context) => LayoutCubit(),
        child: const LayoutEditorPage(),
      ),
    );
  }
}
