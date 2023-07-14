import 'package:dio/dio.dart' as https;
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import 'core/_core.dart';
import 'features/_features.dart';

final getIt = GetIt.instance;

Future<void> setupDependencies() async {
  // [LOCAL DATA SOURCE]
  final dir = await getApplicationDocumentsDirectory();
  final isar = await Isar.open(
    <CollectionSchema<dynamic>>[
      ComicCharacterModelSchema,
    ],
    directory: dir.path,
  );
  getIt.registerSingleton<ComicLocalDataSourceInterface>(
    ComicLocalDataSource(isar: isar),
  );

  // [REMOTE DATA SOURCE]
  getIt.registerSingleton<ComicRemoteDataSourceInterface>(
    ComicRemoteDataSource(
      dio: https.Dio()..options = ComicRemoteDataSource.options,
    ),
  );

  // [NETWORK DATA]
  getIt.registerSingleton<NetworkDataInterface>(
    NetworkData(
      connectionChecker: InternetConnectionChecker(),
    ),
  );

  // [REPOSITORY]
  getIt.registerSingleton<ComicRepositoryInterface>(
    ComicRepository(
      localDataSource: getIt<ComicLocalDataSourceInterface>(),
      remoteDataSource: getIt<ComicRemoteDataSourceInterface>(),
      networkData: getIt<NetworkDataInterface>(),
    ),
  );

  // [USE CASE]
  getIt.registerSingleton<UseCaseInterface<List<ComicCharacterEntity>>>(
    GetComicCharacters(
      repository: getIt<ComicRepositoryInterface>(),
    ),
  );

  // [BLOC]
  getIt.registerSingleton<ComicCharactersBloc>(
    ComicCharactersBloc(
      useCase: getIt<UseCaseInterface<List<ComicCharacterEntity>>>(),
    ),
  );
}
