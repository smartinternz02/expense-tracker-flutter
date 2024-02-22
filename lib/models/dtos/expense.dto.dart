import 'package:expense_app/models/dtos/base.dto.dart';

class ExpenseDTO extends BaseDTO {
  int? id;
  String? name;
  String? expenseDate;
  double? amount;
  int? categoryId;
  String? note;

  ExpenseDTO({
    this.id,
    this.name,
    this.expenseDate,
    this.amount,
    this.categoryId,
    this.note,
  });

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'expenseDate': expenseDate,
      'amount': amount,
      'categoryId': categoryId,
      'note': note,
    };
  }

  @override
  String getTableName() {
    return 'Expense';
  }

  factory ExpenseDTO.fromMap(Map<String, dynamic> map) {
    return ExpenseDTO(
      id: map['Id'] != null ? map['Id'] as int : null,
      name: map['Name'],
      expenseDate: map['ExpenseDate'],
      amount: map['Amount'],
      categoryId: map['CategoryId'],
      note: map['Note'],
    );
  }
}
