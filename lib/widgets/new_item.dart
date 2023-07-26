import 'package:flutter/material.dart';
import 'package:shoppinglist/data/categories.dart';
import 'package:shoppinglist/models/grocery_item.dart';

import '../models/category.dart';

class NewItem extends StatefulWidget {
  const NewItem({Key? key}) : super(key: key);

  @override
  State<NewItem> createState() => _NewItemState();
}

class _NewItemState extends State<NewItem> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _quantityController = TextEditingController(text: '1');
  var _selectedCategory = categories.entries.first.value;

  void _saveItem() {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    Navigator.of(context).pop(GroceryItem(
        id: DateTime.now().toString(),
        name: _nameController.text,
        quantity: int.parse(_quantityController.text),
        category: _selectedCategory));
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a New Item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Name'),
                  validator: (value) {
                    if (value!.isEmpty ||
                        value.trim().length <= 1 ||
                        value.trim().length > 20) {
                      return 'Must be between 1 and 10 characters long.';
                    }
                    return null;
                  },
                  onSaved: (value) {},
                  controller: _nameController,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: TextFormField(
                        decoration:
                            const InputDecoration(labelText: 'Quantity'),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value!.isEmpty ||
                              int.tryParse(value) == null ||
                              int.tryParse(value)! <= 0) {
                            return 'Must be a number greater than 0';
                          }
                          return null;
                        },
                        controller: _quantityController,
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: DropdownButtonFormField(
                          items: [
                            for (final category in categories.entries)
                              DropdownMenuItem(
                                value: category.value,
                                child: Row(
                                  children: [
                                    Container(
                                      width: 24,
                                      height: 24,
                                      color: category.value.color,
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    Text(category.value.title),
                                  ],
                                ),
                              ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _selectedCategory = value as Category;
                            });
                          }),
                    ),
                  ],
                ),
                Row(
                  children: [
                    TextButton(
                      onPressed: () {
                        _formKey.currentState!.reset();
                      },
                      child: const Text('Reset'),
                    ),
                    ElevatedButton(
                      onPressed: _saveItem,
                      child: const Text('Add Item'),
                    ),
                  ],
                ),
              ],
            )),
      ),
    );
  }
}
