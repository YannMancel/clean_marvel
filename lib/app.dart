import 'package:clean_marvel/core/_core.dart';
import 'package:clean_marvel/features/comic/presentation/_presentation.dart';
import 'package:clean_marvel/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: kAppTitle,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: BlocProvider<ComicCharactersBloc>(
        create: (_) {
          final bloc = getIt<ComicCharactersBloc>()
            ..add(
              const ComicCharactersEvent.started(),
            );
          return bloc;
        },
        child: const ComicCharactersPage(title: kAppTitle),
      ),
    );
  }
}
