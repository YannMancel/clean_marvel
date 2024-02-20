import 'package:clean_marvel/core/_core.dart';
import 'package:clean_marvel/features/_features.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

final getIt = GetIt.instance;

Future<void> setupDependencies() async {
  // [LOCAL DATA SOURCE]
  final directory = await getApplicationDocumentsDirectory();
  final isar = await Isar.open(
    const <CollectionSchema<dynamic>>[ComicCharacterModelSchema],
    directory: directory.path,
  );
  getIt.registerSingleton<LocalDatabase>(
    LocalDatabaseByIsar(isar: isar),
  );
  getIt.registerSingleton<ComicCharacterLocalDatabase>(
    ComicCharacterLocalDatabaseImpl(
      localDatabase: getIt<LocalDatabase>(),
    ),
  );

  // [REMOTE DATA SOURCE]
  final dio = Dio()
    ..options = BaseOptions(
      baseUrl: kBaseUrl,
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 3),
    );
  getIt.registerSingleton<RemoteApi>(
    RemoteApiByDio(dio: dio),
  );
  getIt.registerSingleton<ComicCharacterRemoteApi>(
    ComicCharacterRemoteApiImpl(
      remoteApi: getIt<RemoteApi>(),
    ),
  );

  // [NETWORK INFO]
  final connectionChecker = InternetConnectionChecker();
  getIt.registerSingleton<NetworkInfo>(
    NetworkInfoByInternetConnectionChecker(
      connectionChecker: connectionChecker,
    ),
  );

  // [REPOSITORY]
  getIt.registerSingleton<ComicCharacterRepository>(
    ComicCharacterRepositoryImpl(
      networkInfo: getIt<NetworkInfo>(),
      remoteApi: getIt<ComicCharacterRemoteApi>(),
      localDatabase: getIt<ComicCharacterLocalDatabase>(),
    ),
  );

  // [USE CASE]
  getIt.registerSingleton<UseCase<List<ComicCharacterEntity>>>(
    GetComicCharacters(
      repository: getIt<ComicCharacterRepository>(),
    ),
  );

  // [BLOC]
  getIt.registerSingleton<ComicCharactersBloc>(
    ComicCharactersBloc(
      useCase: getIt<UseCase<List<ComicCharacterEntity>>>(),
    ),
  );
}
