import 'package:flutter/material.dart';
import 'package:result_command/result_command.dart';

import '../logic/home.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.model});

  final HomeViewModel model;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListenableBuilder(
          listenable: model.load,
          builder: (context, _) {
            if (model.load.isRunning) {
              return const Center(child: CircularProgressIndicator());
            }

            if (model.load.isFailure) {
              return Center(
                child:
                    Text((model.load.value as FailureCommand).error.toString()),
              );
            }

            return ListView.builder(
              itemCount: model.categories.length,
              itemBuilder: (context, index) {
                final item = model.categories[index];
                return ListTile(
                  title: Text(item.name),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
