import 'package:expense_app/models/category.model.dart';
import 'package:expense_app/services/categories/categories.service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AddExpenseCategoryScreen extends StatefulWidget {
  final ExpenseCategory? expenseCategory;
  const AddExpenseCategoryScreen({super.key, this.expenseCategory});

  @override
  State<AddExpenseCategoryScreen> createState() => _AddExpenseCategoryScreenState();
}

class _AddExpenseCategoryScreenState extends State<AddExpenseCategoryScreen> {
  late ExpenseCategory category;
  bool isEditMode = false;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late IconData selectedIcon;
  late ExpenseCategoryService categoryService = ExpenseCategoryService();
  @override
  void initState() {
    super.initState();
    selectedIcon = ExpenseCategoryService.sampleIcons[0];
    category = ExpenseCategory();

    if (widget.expenseCategory != null) {
      category = widget.expenseCategory!;
      selectedIcon = ExpenseCategoryService.sampleIcons.firstWhere((icon) => icon.codePoint == category.iconPoint, orElse: () => ExpenseCategoryService.sampleIcons[0]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(!isEditMode ? 'Add Category' : 'Edit Category'),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: _buildForm(),
      ),
      persistentFooterButtons: [
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel')),
        FilledButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
              }

              if (!isEditMode) {
                if (await categoryService.addCategory(category) > 0) {
                  Navigator.of(context).pop(true);
                }
              } else {
                if (await categoryService.updateCategory(category)) {
                  Navigator.of(context).pop(true);
                }
              }
            },
            child: const Text('Add'))
      ],
    );
  }

  Widget _buildForm() {
    return Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              initialValue: category.name ?? '',
              decoration: const InputDecoration(hintText: 'Category'),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Enter a category name';
                }

                return null;
              },
              onSaved: (String? value) {
                category.name = value;
                category.iconPoint = selectedIcon.codePoint;
              },
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              margin: const EdgeInsets.symmetric(vertical: 16),
              // height: 250,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 1),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Wrap(
                direction: Axis.horizontal,
                alignment: WrapAlignment.start,
                runSpacing: 30,
                // direction: Axis.horizontal,
                // mainAxisAlignment: MainAxisAlignment.start,
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: ExpenseCategoryService.sampleIcons
                    .map((iconData) => Builder(builder: (context) {
                          return InkWell(
                            onTap: () {
                              setState(() {
                                selectedIcon = iconData;
                              });
                            },
                            child: SizedBox(
                                width: 60,
                                height: 60,
                                child: selectedIcon == iconData
                                    ? Container(
                                        height: 30,
                                        width: 30,
                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: Colors.grey),
                                        child: Icon(iconData),
                                      )
                                    : Icon(iconData)),
                          );
                        }))
                    .toList(),
              ),
            )
          ],
        ));
  }
}
