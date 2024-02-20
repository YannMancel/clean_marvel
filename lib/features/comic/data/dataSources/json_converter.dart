/// **Responsibility**: Manage the conversions between network call and models.
abstract interface class JsonConverter<T> {
  T fromJson(Map<String, dynamic> json);
}
