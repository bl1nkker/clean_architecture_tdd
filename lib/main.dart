import 'package:clean_architecture_tdd/features/number_trivia/presentation/pages/number_trivia_page.dart';
import 'package:flutter/material.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Number Trivia',
      theme: ThemeData(
          primaryColor: Colors.green.shade800,
          colorScheme: ColorScheme.fromSwatch()
              .copyWith(secondary: Colors.green.shade700)),
      home: const NumberTriviaPage(),
    );
  }
}
