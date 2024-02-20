import 'package:clean_marvel/core/_core.dart';
import 'package:dio/dio.dart';

/// **Responsibility**: Group together all the possible actions of a network
/// call in a generic way.
abstract interface class RemoteApi {
  Future<List<T>> get<T>({
    required String endPoint,
    Map<String, dynamic>? queryParameters,
    required List<T> Function(Map<String, dynamic>) on200,
  });
}

class RemoteApiByDio implements RemoteApi {
  RemoteApiByDio({
    required Dio dio,
  }) : _dio = dio;

  final Dio _dio;

  @override
  Future<List<T>> get<T>({
    required String endPoint,
    Map<String, dynamic>? queryParameters,
    required List<T> Function(Map<String, dynamic>) on200,
  }) async {
    try {
      final response = await _dio.get(
        endPoint,
        queryParameters: queryParameters,
      );

      return switch (response.statusCode) {
        200 => on200(response.data as Map<String, dynamic>),
        _ => throw const Failure.server(),
      };
    } on Failure {
      rethrow;
    } catch (_) {
      throw const Failure.unknown();
    }
  }
}
