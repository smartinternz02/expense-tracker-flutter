import 'package:expense_app/models/dtos/expense.dto.dart';
import 'package:expense_app/models/expense.model.dart';
import 'package:expense_app/services/database/app_database.dart';
import 'package:expense_app/utils/date_extensions.dart';

class ExpenseService {
  Future<int> addExpense(Expense expense) {
    var expenseDTO = ExpenseDTO();
    expenseDTO.name = expense.name;
    expenseDTO.amount = expense.amount;
    expenseDTO.expenseDate = expense.expenseDate!.getYYYMMDDHHmmssFormat();
    expenseDTO.categoryId = expense.categoryId;
    expenseDTO.note = expense.note;

    return AppDatabase.insert<ExpenseDTO>(expenseDTO);
  }

  Future<bool> updateExpense(Expense expense) {
    var expenseDTO = ExpenseDTO();
    expenseDTO.id = expense.id;
    expenseDTO.name = expense.name;
    expenseDTO.amount = expense.amount;
    expenseDTO.expenseDate = expense.expenseDate!.getYYYMMDDHHmmssFormat();
    expenseDTO.categoryId = expense.categoryId;
    expenseDTO.note = expense.note;

    return AppDatabase.update<ExpenseDTO>(expenseDTO, whereQuery: "Id = ${expenseDTO.id}");
  }

  Future<List<Expense>> getExpenses() async {
    var expenseMap = await AppDatabase.get('Expense');
    // print(expenseMap);
    var result = expenseMap!.map((map) => ExpenseDTO.fromMap(map)).map((e) {
      var expense = Expense();
      expense.id = e.id;
      expense.amount = e.amount!;
      expense.name = e.name!;
      expense.categoryId = e.categoryId!;
      expense.note = e.note;
      expense.expenseDate = DateTime.parse(e.expenseDate!);

      return expense;
    }).toList();

    return result;
  }

  Future<bool> deleteExpense(int id) {
    return AppDatabase.delete('Expense', where: 'Id = $id');
  }
}
