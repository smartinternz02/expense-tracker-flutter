import 'package:expense_app/screens/add_expense.dart';
import 'package:expense_app/screens/categories.screen.dart';
import 'package:expense_app/screens/expenses_list.screen.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return DashboardScreenState();
  }
}

class DashboardScreenState extends State<DashboardScreen> {
  int currentIndex = 0;
  var pages = const [ExpensesListScreen(), ExpenseCategoriesScreen()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense App'),
      ),
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: navigateToTab,
        currentIndex: currentIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            activeIcon: Icon(Icons.home_filled),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category_rounded),
            label: 'Categories',
            activeIcon: Icon(Icons.category_rounded),
          ),
        ],
      ),
    );
  }

  void navigateToTab(int index) {
    setState(() {
      currentIndex = index;
    });
  }
}
