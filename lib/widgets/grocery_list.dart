import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shoppinglist/data/categories.dart';

import 'package:shoppinglist/models/grocery_item.dart';

import './new_item.dart';

class GroceryList extends StatefulWidget {
  const GroceryList({Key? key}) : super(key: key);

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  List<GroceryItem> _groceryItems = [];
  var _isLoading = true;
  void _loadItem() async {
    final url = Uri.https(
      'flutter-ddbff-default-rtdb.firebaseio.com',
      '/groceryItems.json',
    );

    final response = await http.get(url);
    final Map<String,dynamic> data = json.decode(response.body);
    final List<GroceryItem> loadeditems = [];
    for (final item in data.entries) {
      final category = categories.entries.firstWhere((element) => element.value.title == item.value['category']).value;
      loadeditems.add(
        GroceryItem(
          id: item.key,
          name: item.value['name'],
          quantity: int.parse(item.value['quantity']),
          category: category,
        ),
      );
    }
    setState(() {
      _groceryItems = loadeditems;
      _isLoading = false;
    });
  }

  void _addItem() async {
    final newItem = await Navigator.of(context).push<GroceryItem>(
      MaterialPageRoute(
        builder: (ctx) => const NewItem(),
      ),
    );
    if (newItem != null) {
      setState(() {
        _groceryItems.add(newItem);
      });
    }
  }

  void _removeItem(GroceryItem item){
    final url = Uri.https(
      'flutter-ddbff-default-rtdb.firebaseio.com',
      '/groceryItems/${item.id}.json',
    );
    http.delete(url);
    setState(() {
      _groceryItems.remove(item);
    });
  }

  @override
  void initState() {
    _loadItem();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget content = const Center(
      child: Text('No items yet!'),
    );
    if (_isLoading) {
      content = const Center(
        child: CircularProgressIndicator(),
      );
    }
    if (_groceryItems.isNotEmpty) {
      content = ListView.builder(
        itemCount: _groceryItems.length,
        itemBuilder: (ctx, index) => Dismissible(
          resizeDuration: const Duration(milliseconds: 200),
          dismissThresholds: const {
            DismissDirection.endToStart: 0.2,
            DismissDirection.startToEnd: 0.2,
          },
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            margin: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 4,
            ),
            child: const Icon(
              Icons.delete,
              color: Colors.white,
              size: 20,
            ),
          ),
          key: ValueKey(_groceryItems[index].id),
          onDismissed: (direction) {
            _removeItem(_groceryItems[index]);
          },
          child: ListTile(
            title: Text(_groceryItems[index].name),
            leading: Container(
                width: 24,
                height: 24,
                color: _groceryItems[index].category.color),
            trailing: Text(_groceryItems[index].quantity.toString()),
          ),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Grocery List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              _addItem();
            },
          ),
        ],
      ),
      body: content,
    );
  }
}
