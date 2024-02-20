import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';

/// **Responsibility**: Group together all the possible actions of the local
/// database in a generic way.
abstract interface class LocalDatabase {
  Future<T?> actionsByTransaction<T>({
    required AsyncValueGetter<T> asyncCallback,
  });
  //
  Future<int> addModel<T>(T model);
  Future<List<int>> addModels<T>(List<T> models);
  //
  Future<T?> getModelById<T>(int id);
  Stream<T?> getModelStreamById<T>(int id);
  Future<List<T>> getModels<T>();
  Stream<void> getModelsStream<T>();
  //
  Future<int> updateModel<T>(T model);
  Future<List<int>> updateModels<T>(List<T> models);
  //
  Future<bool> deleteModelById<T>(int id);
  Future<int> deleteModelsByIds<T>(List<int> ids);
  Future<void> deleteModels<T>();
}

class LocalDatabaseByIsar implements LocalDatabase {
  const LocalDatabaseByIsar({
    required Isar isar,
  }) : _isar = isar;

  final Isar _isar;

  @override
  Future<T?> actionsByTransaction<T>({
    required AsyncValueGetter<T> asyncCallback,
  }) async {
    return _isar.writeTxn<T>(asyncCallback);
  }

  @override
  Future<int> addModel<T>(T model) async {
    return _isar.collection<T>().put(model);
  }

  @override
  Future<List<int>> addModels<T>(List<T> models) async {
    return _isar.collection<T>().putAll(models);
  }

  @override
  Future<T?> getModelById<T>(int id) async {
    return _isar.collection<T>().get(id);
  }

  @override
  Stream<T?> getModelStreamById<T>(int id) {
    return _isar.collection<T>().watchObject(id);
  }

  @override
  Future<List<T>> getModels<T>() async {
    return _isar.collection<T>().where().findAll();
  }

  @override
  Stream<void> getModelsStream<T>() {
    return _isar.collection<T>().watchLazy();
  }

  @override
  Future<int> updateModel<T>(T model) async {
    return _isar.collection<T>().put(model);
  }

  @override
  Future<List<int>> updateModels<T>(List<T> models) async {
    return _isar.collection<T>().putAll(models);
  }

  @override
  Future<bool> deleteModelById<T>(int id) async {
    return _isar.collection<T>().delete(id);
  }

  @override
  Future<int> deleteModelsByIds<T>(List<int> ids) async {
    return _isar.collection<T>().deleteAll(ids);
  }

  @override
  Future<void> deleteModels<T>() async {
    return _isar.collection<T>().clear();
  }
}
