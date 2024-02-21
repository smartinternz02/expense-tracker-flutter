// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:expense_app/models/expense.model.dart';

class ExpenseListView {
  late String? expenseDate;
  late List<Expense>? expenses = [];

  ExpenseListView({
    this.expenseDate,
    this.expenses,
  });

  double get total {
    if (expenses!.isEmpty) {
      return 0;
    }

    return expenses!.map((e) => e.amount!).reduce((value, element) => value + element);
  }
}
