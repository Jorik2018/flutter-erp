import 'package:flutter/material.dart';
import '../../models/item.dart';
import 'add_item_view_model.dart';

class AddItemPage extends StatefulWidget {
  static const String route = 'addItem';
  final AddItemViewModel viewModel;
  const AddItemPage(
    this.viewModel, {
    Key? key,
  }) : super(key: key);
  @override
  _AddItemPageState createState() => _AddItemPageState();
}

class _AddItemPageState extends State<AddItemPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _urlController;
  late FocusNode _descriptionFocusNode;
  late FocusNode _urlFocusNode;
  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
    _urlController = TextEditingController();
    _descriptionFocusNode = FocusNode();
    _urlFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _urlController.dispose();
    _descriptionFocusNode.dispose();
    _urlFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wishlist'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: <Widget>[
              const Text('Fill in the details of the item you want to add'),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                onFieldSubmitted: (_) {
                  _descriptionFocusNode.requestFocus();
                },
                validator: _mandatoryValidator,
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                onFieldSubmitted: (_) {
                  _urlFocusNode.requestFocus();
                },
                validator: _mandatoryValidator,
              ),
              TextFormField(
                controller: _urlController,
                decoration: const InputDecoration(labelText: 'URL'),
                validator: _mandatoryValidator,
              ),
              if (widget.viewModel.addingItem) ...const <Widget>[
                SizedBox(height: 32),
                CircularProgressIndicator(),
              ]
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: widget.viewModel.addingItem
            ? null
            : () async {
                await _addItem(context);
              },
        child: const Icon(Icons.save),
      ),
    );
  }

  String? _mandatoryValidator(String? text) {
    return text!.isEmpty ? 'Required' : null;
  }

  Future<void> _addItem(BuildContext context) async {
    try {
      if (_formKey.currentState!.validate()) {
        final Item item = Item(
            name: _nameController.text,
            description: _descriptionController.text,
            url: _urlController.text);
        await widget.viewModel.addItem(item);
        Navigator.of(context).pop(true);
      }
} catch (e, stackTrace) {
    print('Exception: $e');
    print('StackTrace: $stackTrace');
      
      await showDialog(
        context: context,
        builder: (_) => AlertDialog(
          content: const Text('Failed to add the item'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            )
          ],
        ),
      );
    }
  }
}