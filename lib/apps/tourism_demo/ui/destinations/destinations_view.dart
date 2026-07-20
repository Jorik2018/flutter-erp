import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_erp/apps/tourism_demo/i18n/translations.dart';
import 'package:flutter_erp/apps/tourism_demo/ui/common/info_message_view.dart';
import 'package:flutter_erp/apps/tourism_demo/ui/common/loading_view.dart';
import 'package:flutter_erp/apps/tourism_demo/ui/destinations/destinations_view_model.dart';
import 'package:flutter_erp/apps/tourism_demo/ui/destinations/destinations_list.dart';

class DestinationsView extends StatefulWidget {
  final DestinationsViewModel viewModel;

  DestinationsView({required this.viewModel /*, destinations*/});

  @override
  _DestinationsViewState createState() => _DestinationsViewState();
}

class _DestinationsViewState extends State<DestinationsView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LoadingView(
      status: widget.viewModel.status,
      loadingContent: Text(Translations.of(context).loading),
      errorContent: ErrorView(
        onRetry: widget.viewModel.refreshDestinations,
        title: Translations.of(context).msgErrorLoadingDestinations,
        description:
            'AAA' + Translations.of(context).msgCheckInternetConnection,
      ),
      successContent: DestinationsList(
        widget.viewModel.destinationsState!.destinations!,
      ),
    );
  }
}
