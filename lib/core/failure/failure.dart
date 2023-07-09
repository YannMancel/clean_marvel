import 'package:freezed_annotation/freezed_annotation.dart';

part 'failure.freezed.dart';

@freezed
class Failure with _$Failure implements Exception {
  const factory Failure.server() = ServerFailure;
  const factory Failure.cache() = CacheFailure;
  const factory Failure.unknown() = UnknownFailure;
}
