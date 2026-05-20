import 'package:flutter/material.dart';

class ArticlesShowcase extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  Center(
      child:  Text(
        'Articles: TODO',
        style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white),
      ),
    );
  }
}