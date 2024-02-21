class Expense {
  int? id;
  String? name;
  DateTime? expenseDate;
  double? amount;
  int? categoryId;
  String? note;

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'expenseDate': expenseDate.toString(),
      'amount': amount,
      'categoryId': categoryId,
      'note': note,
    };
  }
}
