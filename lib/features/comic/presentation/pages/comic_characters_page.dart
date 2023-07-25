import 'package:clean_marvel/core/_core.dart';
import 'package:clean_marvel/features/comic/presentation/_presentation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ComicCharactersPage extends StatelessWidget {
  const ComicCharactersPage({
    super.key,
    required String title,
  }) : _title = title;

  final String _title;

  @visibleForTesting
  static const titlePropertyName = 'title';

  @visibleForTesting
  static const loadingKey = Key('loading_state');

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      StringProperty(titlePropertyName, _title),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(_title),
          centerTitle: true,
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            context.read<ComicCharactersBloc>().add(
                  const ComicCharactersEvent.refreshed(),
                );
          },
          child: BlocBuilder<ComicCharactersBloc, ComicCharactersState>(
            buildWhen: (previous, current) => previous != current,
            builder: (_, state) => state.when<Widget>(
              loading: () => ScrollViewWithOnlyOneWidget(
                builder: (_) => const CircularProgressIndicator.adaptive(
                  key: loadingKey,
                  semanticsLabel: 'Maestro - Loading state',
                ),
              ),
              data: (entities) => Semantics(
                label: 'Maestro - Data state',
                child: ComicCharactersWidget(entities),
              ),
              error: (exception) => ScrollViewWithOnlyOneWidget(
                builder: (_) => Text(
                  exception is Failure
                      ? exception.when(
                          server: () => 'Server error',
                          cache: () => 'Cache error',
                          unknown: () => 'Unknown error',
                        )
                      : 'No catch error',
                  semanticsLabel: 'Maestro - Error state',
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
