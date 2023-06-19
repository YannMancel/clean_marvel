import 'package:freezed_annotation/freezed_annotation.dart';

part 'result.freezed.dart';

@freezed
class Result<T> with _$Result<T> {
  const factory Result.data(T value) = _Data<T>;
  const factory Result.error({required Exception exception}) = _Error<T>;
}
