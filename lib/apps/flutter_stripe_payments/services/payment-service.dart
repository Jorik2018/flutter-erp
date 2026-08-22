import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class StripeTransactionResponse {
  final String message;
  final bool success;

  const StripeTransactionResponse({
    required this.message,
    required this.success,
  });
}

class StripeService {
  StripeService._();

  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://tu-backend.com',
      headers: {'Content-Type': 'application/json'},
    ),
  );

  static Future<void> init({required String publishableKey}) async {
    Stripe.publishableKey = publishableKey;

    await Stripe.instance.applySettings();
  }

  static Future<String> createPaymentIntent({
    required int amount,
    required String currency,
  }) async {
    final response = await _dio.post(
      '/payments/create-intent',
      data: {'amount': amount, 'currency': currency},
    );

    final data = response.data;

    if (data is! Map<String, dynamic>) {
      throw StateError('Invalid response from payment backend');
    }

    final clientSecret = data['clientSecret'];

    if (clientSecret is! String || clientSecret.isEmpty) {
      throw StateError('Backend did not return a clientSecret');
    }

    return clientSecret;
  }

  static Future<StripeTransactionResponse> payWithNewCard({
    required int amount,
    required String currency,
  }) async {
    try {
      final clientSecret = await createPaymentIntent(
        amount: amount,
        currency: currency,
      );

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: 'My App',
        ),
      );

      await Stripe.instance.presentPaymentSheet();

      return const StripeTransactionResponse(
        message: 'Transaction successful',
        success: true,
      );
    } on StripeException catch (error) {
      return StripeTransactionResponse(
        message:
            error.error.localizedMessage ?? 'Transaction cancelled or failed',
        success: false,
      );
    } catch (error) {
      return StripeTransactionResponse(
        message: 'Transaction failed: $error',
        success: false,
      );
    }
  }
}
