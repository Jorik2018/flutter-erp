import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class ExistingCardsPage extends StatefulWidget {
  const ExistingCardsPage({super.key});

  @override
  State<ExistingCardsPage> createState() => ExistingCardsPageState();
}

class ExistingCardsPageState extends State<ExistingCardsPage> {
  final List<Map<String, dynamic>> cards = [
    {
      'cardNumber': '4242424242424242',
      'expiryDate': '04/28',
      'cardHolderName': 'Muhammad Ahsan Ayaz',
      'cvvCode': '424',
    },
    {
      'cardNumber': '5555555555554444',
      'expiryDate': '04/29',
      'cardHolderName': 'Tracer',
      'cvvCode': '123',
    },
  ];

  Future<void> payViaExistingCard(
    BuildContext context,
    Map<String, dynamic> card,
  ) async {
    _showLoading();

    try {
      //
      // IMPORTANTE:
      // Este clientSecret debe venir de TU BACKEND.
      //
      final clientSecret = await _createPaymentIntentOnBackend(
        amount: 2500,
        currency: 'usd',
      );

      await Stripe.instance.confirmPayment(
        paymentIntentClientSecret: clientSecret,
        data: PaymentMethodParams.card(
          paymentMethodData: PaymentMethodData(
            billingDetails: BillingDetails(
              name: card['cardHolderName'] as String?,
            ),
          ),
        ),
      );

      if (!mounted) {
        return;
      }

      Navigator.of(context, rootNavigator: true).pop();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Payment successful'),
          duration: Duration(milliseconds: 1200),
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) {
        return;
      }

      Navigator.of(context, rootNavigator: true).pop();

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Payment failed: $e')));
    }
  }

  Future<String> _createPaymentIntentOnBackend({
    required int amount,
    required String currency,
  }) async {
    // TODO:
    // Aquí debes llamar a tu API.
    //
    // Ejemplo de respuesta esperada:
    //
    // {
    //   "clientSecret": "pi_xxx_secret_xxx"
    // }
    //
    throw UnimplementedError('Connect this method to your backend');
  }

  void _showLoading() {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Choose existing card')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView.builder(
          itemCount: cards.length,
          itemBuilder: (context, index) {
            final card = cards[index];

            return InkWell(
              onTap: () {
                payViaExistingCard(context, card);
              },
              child: CreditCardWidget(
                cardNumber: card['cardNumber'] as String,
                expiryDate: card['expiryDate'] as String,
                cardHolderName: card['cardHolderName'] as String,
                cvvCode: card['cvvCode'] as String,
                showBackView: false,
                onCreditCardWidgetChange: (_) {},
              ),
            );
          },
        ),
      ),
    );
  }
}
