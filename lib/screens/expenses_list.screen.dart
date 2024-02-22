import 'package:expense_app/models/category.model.dart';
import 'package:expense_app/models/expense.model.dart';
import 'package:expense_app/models/viewmodels/expense_list.model.dart';
import 'package:expense_app/screens/add_expense.dart';
import 'package:expense_app/services/categories/categories.service.dart';
import 'package:expense_app/services/expenses/expense.service.dart';
import 'package:expense_app/utils/date_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
  ExpenseCategoryService categoryService = ExpenseCategoryService();
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
        child: expenseListItems.isNotEmpty
            ? Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
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
                            leading: CircleAvatar(child: Icon(IconData(expense.categoryIcon!, fontFamily: 'MaterialIcons'))),
                            title: Text(expense.name!),
                            subtitle: Text(expense.categoryName ?? ''),
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
              )
            : _showEmptyScreen(),
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
    var categories = await categoryService.getCategories();
    if (expenses.isNotEmpty) {
      Map<String, List<Expense>> groupedExpenses = {};
      for (var expense in expenses) {
        String key = DateTimeUtils.getDayMonthDayYearFormat(expense.expenseDate!);
        if (expense.categoryId != null) {
          ExpenseCategory category = categories.firstWhere((c) => c.id == expense.categoryId);
          expense.categoryName = category.name!;
          expense.categoryIcon = category.iconPoint;
        }

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

  Widget _showEmptyScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 200,
            width: 200,
            child: SvgPicture.asset('assets/images/no_data.svg'),
          ),
          const SizedBox(height: 15),
          const Text('No expenses added', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        ],
      ),
    );
  }
}
