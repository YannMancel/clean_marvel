import 'dart:async';

import 'package:clean_marvel/features/_features.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ComicCharactersBloc
    extends Bloc<ComicCharactersEvent, ComicCharactersState> {
  ComicCharactersBloc({
    ComicCharactersState? initialState,
    required UseCase<List<ComicCharacterEntity>> useCase,
  })  : _useCase = useCase,
        super(
          initialState ?? const ComicCharactersState.loading(),
        ) {
    on<StartedEvent>(_onStarted);
    on<RefreshedEvent>(_onRefreshed);
  }

  final UseCase<List<ComicCharacterEntity>> _useCase;

  FutureOr<void> _onStarted(
    StartedEvent event,
    Emitter<ComicCharactersState> emit,
  ) async {
    emit(
      const ComicCharactersState.loading(),
    );

    final result = await _useCase();

    emit(
      result.when<ComicCharactersState>(
        data: (entities) => ComicCharactersState.data(entities: entities),
        error: (exception) => ComicCharactersState.error(exception: exception),
      ),
    );
  }

  FutureOr<void> _onRefreshed(
    RefreshedEvent event,
    Emitter<ComicCharactersState> emit,
  ) async {
    add(
      const ComicCharactersEvent.started(),
    );
  }
}
