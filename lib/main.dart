import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'presentation/screens/asset_chart_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  runApp(const CoinalyzeApp());
}

class CoinalyzeApp extends StatelessWidget {
  const CoinalyzeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Coinalyze',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF131722),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2962FF),
          brightness: Brightness.dark,
        ),
      ),
      home: const AssetChartScreen(),
    );
  }
}
