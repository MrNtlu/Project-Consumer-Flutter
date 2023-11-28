class TypeConverter<T> {
  T convertToObject(Map<String,dynamic> response) {
    return response as T;
  }
}