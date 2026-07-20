import 'package:flutter/material.dart';
import 'package:flutter_erp/apps/foda_admin/components/app_scaffold.dart';

class TransactionsPage extends StatelessWidget {
  const TransactionsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appbar: AppBar(title: const Text("Transactions")),
      body: Container(),
    );
  }
}
