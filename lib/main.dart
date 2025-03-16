import 'package:flutter/material.dart';

import 'data/repository.dart';
import 'data/service_local.dart';
import 'logic/home.dart';
import 'ui/home_screen.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final service = LocalService(LocalAssetLoader());
    final repo = CacheRepository(service);
    final model = HomeViewModel(repo: repo);

    return MaterialApp(
      title: 'Kite',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
      ),
      home: HomeScreen(model: model),
    );
  }
}
