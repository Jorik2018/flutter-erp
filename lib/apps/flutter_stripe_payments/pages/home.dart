import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  Future<void> onItemPress(BuildContext context, int index) async {
    switch (index) {
      case 0:
        await payViaNewCard(context);
        break;

      case 1:
        if (!context.mounted) {
          return;
        }

        Navigator.pushNamed(context, '/existing-cards');
        break;
    }
  }

  Future<void> payViaNewCard(BuildContext context) async {
    _showLoadingDialog();

    try {
      final clientSecret = await _createPaymentIntentOnBackend(
        amount: 15000,
        currency: 'usd',
      );

      if (!mounted) {
        return;
      }

      Navigator.of(context, rootNavigator: true).pop();

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: 'My App',
        ),
      );

      await Stripe.instance.presentPaymentSheet();

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Payment successful'),
          duration: Duration(milliseconds: 1200),
        ),
      );
    } on StripeException catch (e) {
      if (!mounted) {
        return;
      }

      _closeLoadingDialogIfNeeded();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.error.localizedMessage ?? 'Payment cancelled or failed',
          ),
          duration: const Duration(milliseconds: 3000),
        ),
      );
    } catch (e) {
      if (!mounted) {
        return;
      }

      _closeLoadingDialogIfNeeded();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Payment error: $e'),
          duration: const Duration(milliseconds: 3000),
        ),
      );
    }
  }

  Future<String> _createPaymentIntentOnBackend({
    required int amount,
    required String currency,
  }) async {
    /*
     * Aquí debes llamar a TU backend.
     *
     * Por ejemplo:
     *
     * POST /payments/create-intent
     *
     * {
     *   "amount": 15000,
     *   "currency": "usd"
     * }
     *
     * Y tu backend devuelve:
     *
     * {
     *   "clientSecret": "pi_xxx_secret_xxx"
     * }
     */

    throw UnimplementedError('Connect payment creation to your backend');
  }

  void _showLoadingDialog() {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  void _closeLoadingDialogIfNeeded() {
    if (Navigator.of(context, rootNavigator: true).canPop()) {
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView.separated(
          itemCount: 2,
          separatorBuilder: (_, __) {
            return Divider(color: theme.primaryColor);
          },
          itemBuilder: (context, index) {
            late final Icon icon;
            late final Text text;

            switch (index) {
              case 0:
                icon = Icon(Icons.add_circle, color: theme.primaryColor);
                text = const Text('Pay via card');
                break;

              case 1:
                icon = Icon(Icons.credit_card, color: theme.primaryColor);
                text = const Text('Pay via existing card');
                break;

              default:
                return const SizedBox.shrink();
            }

            return InkWell(
              onTap: () {
                onItemPress(context, index);
              },
              child: ListTile(title: text, leading: icon),
            );
          },
        ),
      ),
    );
  }
}
