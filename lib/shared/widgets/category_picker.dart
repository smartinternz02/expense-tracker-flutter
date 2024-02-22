import 'package:expense_app/models/category.model.dart';
import 'package:flutter/material.dart';

class ExpenseCategoryPicker extends StatefulWidget {
  final List<ExpenseCategory> expenseCategories;
  final ExpenseCategory? selectedCategory;
  final Function(ExpenseCategory)? onCategorySelected;

  const ExpenseCategoryPicker({
    super.key,
    required this.expenseCategories,
    this.onCategorySelected,
    this.selectedCategory,
  });

  @override
  State<ExpenseCategoryPicker> createState() => _ExpenseCategoryPickerState();
}

class _ExpenseCategoryPickerState extends State<ExpenseCategoryPicker> {
  int? selectedIcon;

  @override
  void initState() {
    super.initState();

    if (widget.selectedCategory != null) {
      selectedIcon = widget.selectedCategory!.iconPoint;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      margin: const EdgeInsets.symmetric(vertical: 16),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 1),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Choose a category'),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 20),
            child: Wrap(
              direction: Axis.horizontal,
              alignment: WrapAlignment.start,
              runSpacing: 30,
              children: widget.expenseCategories
                  .map((category) => InkWell(
                        onTap: () {
                          setState(() {
                            selectedIcon = category.iconPoint;
                          });

                          if (widget.onCategorySelected != null) {
                            widget.onCategorySelected!(category);
                          }
                        },
                        child: UnconstrainedBox(
                          child: SizedBox(
                            height: 45,
                            child: category.iconPoint == selectedIcon
                                ? Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8),
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: Theme.of(context).highlightColor),
                                    child: Row(
                                      children: [Icon(IconData(category.iconPoint!, fontFamily: 'MaterialIcons')), const SizedBox(width: 5), Text(category.name!)],
                                    ),
                                  )
                                : Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                    child: Row(
                                      children: [Icon(IconData(category.iconPoint!, fontFamily: 'MaterialIcons')), const SizedBox(width: 5), Text(category.name!)],
                                    ),
                                  ),
                          ),
                        ),
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
