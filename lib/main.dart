import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'config/theme.dart';
import 'data/repository.dart';
import 'data/service_remote.dart';
import 'logic/home.dart';
import 'ui/home_screen.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final service = RemoteService(http.Client());
    final repo = CacheRepository(service);
    final model = HomeViewModel(repo: repo);

    return MaterialApp(
      title: 'Kite',
      theme: AppTheme.theme,
      home: HomeScreen(model: model),
    );
  }
}
