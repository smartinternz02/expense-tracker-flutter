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
        backgroundColor: Theme.of(context).primaryColorLight,
      ),
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedFontSize: 14,
        onTap: navigateToTab,
        currentIndex: currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: 'Home',
            activeIcon: const Icon(Icons.home_filled),
            backgroundColor: Theme.of(context).highlightColor,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.category),
            label: 'Categories',
            activeIcon: const Icon(Icons.category_rounded),
            backgroundColor: Theme.of(context).highlightColor,
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
