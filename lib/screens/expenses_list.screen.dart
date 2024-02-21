import 'package:expense_app/models/expense.model.dart';
import 'package:expense_app/models/viewmodels/expense_list.model.dart';
import 'package:expense_app/screens/add_expense.dart';
import 'package:expense_app/services/expenses/expense.service.dart';
import 'package:expense_app/utils/datetimeutils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ExpensesListScreen extends StatefulWidget {
  const ExpensesListScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return ExpensesListScreenState();
  }
}

class ExpensesListScreenState extends State<ExpensesListScreen> {
  ExpenseService expenseService = ExpenseService();
  List<Expense> expenses = [];

  late List<ExpenseListView> expenseListItems = [];
  bool _isLoading = false;
  final formatCurrency = NumberFormat.simpleCurrency(locale: 'en-IN', decimalDigits: 2);

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    expenseListItems = [];
    fetchExpenses();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: fetchExpenses,
        child: ListView.builder(
            itemCount: expenseListItems.length,
            itemBuilder: (context, index) {
              var key = expenseListItems[index].expenseDate;
              var widgets = expenseListItems[index].expenses!.map((expense) {
                return InkWell(
                  onTap: () {
                    _openEditExpense(expense);
                  },
                  child: ListTile(
                    title: Text(expense.name!),
                    subtitle: Text(expense.note ?? ''),
                    trailing: Text(
                      formatCurrency.format(expense.amount),
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                );
              }).toList();

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: SizedBox(
                      height: 20,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(key!, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          Text('Overall: ${formatCurrency.format(expenseListItems[index].total)}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              )),
                        ],
                      ),
                    ),
                  ),
                  ...widgets
                ],
              );
            }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: openAddExpenseScreen,
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> fetchExpenses() async {
    expenseListItems = [];
    var expenses = await expenseService.getExpenses();
    if (expenses.isNotEmpty) {
      Map<String, List<Expense>> groupedExpenses = {};
      for (var expense in expenses) {
        String key = DateTimeUtils.getDayMonthDayYearFormat(expense.expenseDate!);
        if (!groupedExpenses.containsKey(key)) {
          groupedExpenses[key] = [expense];
        } else {
          groupedExpenses[key]!.add(expense);
        }
      }

      groupedExpenses.forEach((key, expenses) {
        expenseListItems.add(ExpenseListView(expenseDate: key, expenses: expenses));
      });
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _openEditExpense(Expense expense) async {
    var shouldRefresh = await Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return AddExpenseScreen(expense: expense);
    }));

    if (shouldRefresh != null && shouldRefresh) {
      fetchExpenses();
    }
  }

  void openAddExpenseScreen() async {
    var shouldRefresh = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => const AddExpenseScreen(),
          fullscreenDialog: true,
        ));

    if (shouldRefresh != null && shouldRefresh) {
      fetchExpenses();
    }
  }
}
