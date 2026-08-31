import 'package:flutter/material.dart';
import 'package:flutter_erp/apps/verido/widgets/Card.dart';
import 'package:flutter_erp/apps/verido/Widgets/MyAppBar.dart';
import 'package:flutter_erp/apps/verido/Widgets/Drawer.dart';

class Assignment3 extends StatefulWidget {
  const Assignment3({super.key});

  @override
  State<Assignment3> createState() => _Assignment3State();
}

class _Assignment3State extends State<Assignment3> {
  final List<Map<String, dynamic>> items = [
    {
      'id': 1,
      'title': 'Card 1 Title',
      'description':
          'Greyhound divisively hello coldly wonderfully marginally far upon excluding.',
    },
    {
      'id': 2,
      'title': 'Card 2 Title',
      'description':
          'Greyhound divisively hello coldly wonderfully marginally far upon excluding.',
    },
    {
      'id': 3,
      'title': 'Card 3 Title',
      'description':
          'Greyhound divisively hello coldly wonderfully marginally far upon excluding.',
    },
    {
      'id': 4,
      'title': 'Card 4 Title',
      'description':
          'Greyhound divisively hello coldly wonderfully marginally far upon excluding.',
    },
    {
      'id': 5,
      'title': 'Card 5 Title',
      'description':
          'Greyhound divisively hello coldly wonderfully marginally far upon excluding.',
    },
    {
      'id': 6,
      'title': 'Card 6 Title',
      'description':
          'Greyhound divisively hello coldly wonderfully marginally far upon excluding.',
    },
    {
      'id': 7,
      'title': 'Card 7 Title',
      'description':
          'Greyhound divisively hello coldly wonderfully marginally far upon excluding.',
    },
  ];

  Future<bool> _confirmDelete() async {
    final ConfirmAction? action = await showDialog<ConfirmAction>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete This Card?'),
          content: const Text('This will delete the card from today\'s list.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(ConfirmAction.cancel);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(ConfirmAction.accept);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    return action == ConfirmAction.accept;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      drawer: SizedBox(
        width: MediaQuery.sizeOf(context).width * 0.65,
        child: DrawerWidget(),
      ),
      body: Container(
        margin: const EdgeInsets.only(top: 20),
        child: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];

            return Dismissible(
              key: ValueKey(item['id']),
              direction: DismissDirection.endToStart,
              background: Container(
                color: Colors.red.shade300,
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 24),
                child: const Icon(Icons.delete, color: Colors.white),
              ),

              // Se pregunta antes de eliminar.
              confirmDismiss: (_) => _confirmDelete(),

              onDismissed: (_) {
                setState(() {
                  items.removeAt(index);
                });
              },
              child: MyCard(
                title: item['title'] as String,
                description: item['description'] as String,
                image: 'lib/assets/smash3.jpg',
              ),
            );
          },
        ),
      ),
    );
  }
}

enum ConfirmAction { cancel, accept }
