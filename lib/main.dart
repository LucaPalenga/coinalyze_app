import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'constants/theme/theme.dart';
import 'constants/theme/util.dart';
import 'l10n/generated/app_localizations.dart';
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
    final textTheme = createTextTheme(context, 'Roboto', 'Roboto');
    final theme = MaterialTheme(textTheme);

    return MaterialApp(
      title: 'Coinalyze',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      darkTheme: theme.dark(),
      themeMode: ThemeMode.dark,
      home: const AssetChartScreen(),
    );
  }
}
