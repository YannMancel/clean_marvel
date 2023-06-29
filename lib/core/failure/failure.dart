import 'package:freezed_annotation/freezed_annotation.dart';

part 'failure.freezed.dart';

@freezed
class Failure with _$Failure implements Exception {
  const factory Failure.server() = _Servor;
  const factory Failure.cache() = _Cache;
  const factory Failure.unknown() = _Unknown;
}
