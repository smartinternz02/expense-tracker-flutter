abstract class BaseDTO {
  String getTableName();

  Map<String, Object?> toMap();
}
