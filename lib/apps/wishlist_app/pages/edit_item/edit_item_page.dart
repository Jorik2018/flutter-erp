import 'package:flutter/material.dart';
import '../../models/item.dart';
import 'edit_item_view_model.dart';

class EditItemPage extends StatefulWidget {
  static const String route = 'editItem';
  final Item item;
  final EditItemViewModel viewModel;
  const EditItemPage(
    this.item,
    this.viewModel, {
    Key? key,
  }) : super(key: key);
  @override
  _EditItemPageState createState() => _EditItemPageState();
}

class _EditItemPageState extends State<EditItemPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _urlController;
  late FocusNode _descriptionFocusNode;
  late FocusNode _urlFocusNode;
  @override
  void initState() {
    super.initState();
    final Item item = widget.item;
    _nameController = TextEditingController(text: item.name);
    _descriptionController = TextEditingController(text: item.description);
    _urlController = TextEditingController(text: item.url);
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
              const Text('Fill in the details of the item you want to edit'),
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
              if (widget.viewModel.editingItem) ...const <Widget>[
                SizedBox(height: 32),
                CircularProgressIndicator(),
              ]
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: widget.viewModel.editingItem
            ? null
            : () async {
                await _editItem(context);
              },
        child: const Icon(Icons.save),
      ),
    );
  }

  String? _mandatoryValidator(String? text) {
    return text!.isEmpty ? 'Required' : null;
  }

  Future<void> _editItem(BuildContext context) async {
    try {
      if (_formKey.currentState!.validate()) {
        final Item item = Item(
            id: widget.item.id,
            name: _nameController.text,
            description: _descriptionController.text,
            url: _urlController.text);
        await widget.viewModel.editItem(item);
        Navigator.of(context).pop(true);
      }
    } on Exception {
      await showDialog(
        context: context,
        builder: (_) => AlertDialog(
          content: const Text('Failed to edit the item'),
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