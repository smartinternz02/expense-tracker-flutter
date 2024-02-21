import 'package:expense_app/models/category.model.dart';
import 'package:expense_app/screens/add_category.screen.dart';
import 'package:expense_app/services/categories/categories.service.dart';
import 'package:expense_app/services/expenses/expense.service.dart';
import 'package:flutter/material.dart';

class ExpenseCategoriesScreen extends StatefulWidget {
  const ExpenseCategoriesScreen({super.key});

  @override
  State<ExpenseCategoriesScreen> createState() => _ExpenseCategoriesScreenState();
}

class _ExpenseCategoriesScreenState extends State<ExpenseCategoriesScreen> {
  ExpenseCategoryService expenseCategoryService = ExpenseCategoryService();
  List<ExpenseCategory> expenseCategories = [];
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    isLoading = true;
    fetchCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: fetchCategories,
        child: ListView.builder(
            itemCount: expenseCategories.length,
            itemBuilder: (context, index) {
              var icon = ExpenseCategoryService.sampleIcons.firstWhere((element) => element.codePoint == expenseCategories[index].iconPoint);
              return InkWell(
                onTap: () {
                  _editCategory(expenseCategories[index]);
                },
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                  leading: CircleAvatar(
                    child: Icon(icon),
                  ),
                  title: Text(expenseCategories[index].name!),
                ),
              );
            }),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'categoryScreen',
        onPressed: _addCategory,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _addCategory() async {
    var shouldRefresh = await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) {
          return const AddExpenseCategoryScreen();
        },
        fullscreenDialog: true));

    if (shouldRefresh != null && shouldRefresh) {
      fetchCategories();
    }
  }

  void _editCategory(ExpenseCategory category) async {
    var shouldRefresh = await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) {
          return AddExpenseCategoryScreen(
            expenseCategory: category,
          );
        },
        fullscreenDialog: true));

    if (shouldRefresh != null && shouldRefresh) {
      fetchCategories();
    }
  }

  Future<void> fetchCategories() async {
    expenseCategories = await expenseCategoryService.getCategories();
    setState(() {
      isLoading = false;
    });
  }
}
