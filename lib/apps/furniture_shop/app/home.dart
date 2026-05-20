import 'package:flutter/material.dart';

import '../model/furniture.dart';

import 'furniture_list/furniture_grid_view.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String productDropped = 'On Product Drop Text will update';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.menu,
          ),
          onPressed: () {
            print('Menu button pressed');
          },
        ),
      ),
      body: Row(
        children: [
          Container(
            width: MediaQuery.of(context).size.width * .45,
            height: MediaQuery.of(context).size.height - 72,
            padding: const EdgeInsets.all(16),
            child: FurnitureGrid(
              furnitures: Furniture.list,
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * .45,
            height: MediaQuery.of(context).size.height - 72,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Card(
                  child: SizedBox(
                    height: 40,
                    child: Center(
                      child: Text(
                        productDropped,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Card(
                  color: Colors.pink.withOpacity(.1),
                  child: SizedBox(
                    height: 500,
                    child: _furnitureDragTarget,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget get _furnitureDragTarget {
    return DragTarget<Furniture>(
      builder: (context, candidateData, rejectedData) {
        return const Center(
          child: Text(
            'Drag and Drop',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 16,
            ),
          ),
        );
      },
      onWillAccept: (data) => true,
      onAccept: (data) {
        setState(() => productDropped = data.name!);
      },
    );
  }
}
