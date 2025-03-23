import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:result_command/result_command.dart';

import '../config/theme.dart';
import '../logic/categories.dart';
import '../logic/home.dart';
import 'articles_view.dart';
import 'categories_view.dart';
import 'core/spacing.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.model});

  final HomeViewModel model;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Category? selected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListenableBuilder(
          listenable: widget.model.load,
          builder: (context, _) {
            if (widget.model.load.isRunning) {
              return const Center(child: CircularProgressIndicator());
            }

            if (widget.model.load.isFailure) {
              final err = (widget.model.load.value as FailureCommand).error;
              log('an error occurred loading categories: $err');
              return _ErrorView(
                err,
                onRetry: () => widget.model.retry(),
              );
            }

            return _SuccessView(
              widget.model.categories,
              selected ?? widget.model.categories.first,
              (category) {
                setState(() {
                  selected = category;
                });
              },
            );
          },
        ),
      ),
    );
  }
}

class _SuccessView extends StatelessWidget {
  const _SuccessView(
    this._categories,
    this.selected,
    this.onSelected, {
    super.key,
  });

  final Category selected;
  final List<Category> _categories;
  final ValueChanged<Category> onSelected;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          floating: true,
          forceMaterialTransparency: true,
          flexibleSpace: CategoriesView(
            _categories,
            selected,
            onSelected: onSelected,
          ),
        ),
        ArticlesView(selected),
      ],
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView(this.error, {required this.onRetry, super.key});

  final Exception error;
  final VoidCallback onRetry;

  static const _buttonText = 'Retry';
  static const _titleText = 'Oops!';
  static const _subtitleText =
      'We couldn\'t load any articles. Something went wrong:';

  (String type, String message) _prettyPrint(Exception error) {
    final raw = error.toString();
    final split = raw.split(': ');

    if (split.length == 2) {
      return (split[0], split[1]);
    }

    return ('', raw);
  }

  @override
  Widget build(BuildContext context) {
    final (type, message) = _prettyPrint(error);

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            spacing: 4,
            children: [
              Spacing.s32,
              Container(
                height: MediaQuery.of(context).size.width * 0.5,
                width: MediaQuery.of(context).size.width * 0.5,
                decoration: BoxDecoration(
                  color: Colours.iconButtonBg,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  LucideIcons.banana,
                  size: MediaQuery.of(context).size.width * 0.25,
                  color: Colours.iconButton,
                ),
              ),
              Spacing.s32,
              Text(_titleText, style: Styles.title),
              Text(
                _subtitleText,
                style: Styles.subtitle,
                textAlign: TextAlign.center,
              ),
              Spacing.s16,
              if (type.isNotEmpty) Text(type, style: Styles.minititle),
              Text(message, style: Styles.body, textAlign: TextAlign.center),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FilledButton(
                onPressed: onRetry,
                child: Text(_buttonText),
              ),
            ],
          )
        ],
      ),
    );
  }
}
