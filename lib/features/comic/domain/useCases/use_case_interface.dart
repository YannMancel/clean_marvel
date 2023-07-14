import 'package:clean_marvel/core/_core.dart';

abstract interface class UseCaseInterface<T> {
  Future<Result<T>> call();
}
