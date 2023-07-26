import 'package:flutter/material.dart';
import 'package:shoppinglist/data/categories.dart';

class NewItem extends StatefulWidget {
  const NewItem({Key? key}) : super(key: key);

  @override
  State<NewItem> createState() => _NewItemState();
}

class _NewItemState extends State<NewItem> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a New Item'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
            child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: 'Name'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter a name';
                }
                return null;
              },
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(labelText: 'Quantity'),
                    keyboardType: TextInputType.number,
                    initialValue: '1',
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: DropdownButtonFormField(items: [
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
                  ], onChanged: (value) {}),
                ),
              ],
            ),
            const Row(
              children: [
                TextButton(
                  onPressed: null,
                  child: Text('Reset'),
                ),
                ElevatedButton(
                  onPressed:null
                  ,
                  child: Text('Add Item'),
                ),
              ],
            ),
          ],
        )),
      ),
    );
  }
}
