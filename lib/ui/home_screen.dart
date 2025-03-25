import 'dart:developer';

import 'package:flutter/cupertino.dart';
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
              return _LoadingView();
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
              onSelected: (category) {
                setState(() {
                  selected = category;
                });
              },
              onArticleRead: (article, read) {
                final category =
                    selected?.name ?? widget.model.categories.first.name;
                widget.model.markArticle(category, article, read: read);
                // TODO: force ui rebuild
              },
              onRefresh: () async {
                await widget.model.refresh();
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
    this.selected, {
    required this.onSelected,
    required this.onArticleRead,
    required this.onRefresh,
  });

  final Category selected;
  final List<Category> _categories;
  final ValueChanged<Category> onSelected;
  final ReadStatusChanged onArticleRead;
  final Future<void> Function() onRefresh;

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
        // TODO: customise refresh indicator via builder
        CupertinoSliverRefreshControl(
          onRefresh: onRefresh,
        ),
        ArticlesView(selected, onArticleRead),
      ],
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView(this.error, {required this.onRetry});

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

class _LoadingView extends StatefulWidget {
  const _LoadingView();

  static const _shimmerPrimary = Color(0xFFF4F4F4);
  static const _shimmerSecondary = Color(0xFFEBEBF4);

  static const _shimmerGradient = LinearGradient(
    colors: [_shimmerSecondary, _shimmerPrimary, _shimmerSecondary],
    stops: [0.1, 0.3, 0.4],
    begin: Alignment(-1.0, -0.1),
    end: Alignment(1.0, 0.1),
    tileMode: TileMode.clamp,
  );

  @override
  State<_LoadingView> createState() => _LoadingViewState();
}

class _LoadingViewState extends State<_LoadingView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  LinearGradient get gradient => LinearGradient(
        colors: _LoadingView._shimmerGradient.colors,
        stops: _LoadingView._shimmerGradient.stops,
        begin: _LoadingView._shimmerGradient.begin,
        end: _LoadingView._shimmerGradient.end,
        tileMode: _LoadingView._shimmerGradient.tileMode,
        transform: _LoadingTransform(_controller.value),
      );

  @override
  void initState() {
    super.initState();

    _controller = AnimationController.unbounded(vsync: this)
      ..repeat(min: -0.5, max: 1.5, period: const Duration(milliseconds: 1200));

    _controller.addListener(_onShimmerChange);
  }

  @override
  void dispose() {
    _controller.removeListener(_onShimmerChange);
    _controller.dispose();
    super.dispose();
  }

  void _onShimmerChange() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcATop,
      shaderCallback: (bounds) => gradient.createShader(bounds),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          children: [
            Flexible(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    spacing: 8,
                    children: [
                      ...[12, 10, 16, 18, 14].map(
                        (size) => Chip(
                          label: Text(' ' * size),
                          backgroundColor: Colors.black,
                          side: BorderSide.none,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Spacing.s4,
            ...[14, 12].map(
              (size) => Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 12.0,
                ),
                child: Row(
                  children: [
                    Flexible(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Chip(
                            label: Text(' ' * size),
                            padding: EdgeInsets.symmetric(horizontal: 2.0),
                            visualDensity: VisualDensity.compact,
                            backgroundColor: Colors.black,
                            side: BorderSide.none,
                          ),
                          Spacing.s8,
                          Container(
                            width: double.infinity,
                            height: 32,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          Spacing.s4,
                          Container(
                            width: MediaQuery.of(context).size.width * 0.6,
                            height: 32,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          Spacing.s12,
                          Container(
                            width: MediaQuery.of(context).size.width * 0.25,
                            height: 20,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          Spacing.s16,
                          Divider(
                            color: Colours.divider,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoadingTransform extends GradientTransform {
  const _LoadingTransform(this.slidePercent);

  final double slidePercent;

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.translationValues(bounds.width * slidePercent, 0, 0);
  }
}
