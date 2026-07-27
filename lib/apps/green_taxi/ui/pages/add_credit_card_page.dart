import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:flutter_erp/apps/green_taxi/ui/widgets/header_widget.dart';
import 'package:flutter_erp/apps/green_taxi/utils/styles.dart';

class AddCreditCardPage extends StatefulWidget {
  static final routeName = "add-credit-card";

  @override
  _AddCreditCardPageState createState() => _AddCreditCardPageState();
}

class _AddCreditCardPageState extends State<AddCreditCardPage> {
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;

  void onCreditCardModelChange(CreditCardModel creditCardModel) {
    setState(() {
      cardNumber = creditCardModel.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
  }

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final mQ = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          Container(width: mQ.width, height: mQ.height),
          NoLogoHeaderWidget(height: mQ.height * 0.5),
          Positioned(
            top: 100,
            left: 10,
            right: 10,
            child: Container(
              width: mQ.width,
              height: mQ.height * 0.8,
              child: Column(
                children: <Widget>[
                  CreditCardWidget(
                    onCreditCardWidgetChange:
                        (CreditCardBrand creditCardBrand) {},
                    cardBgColor: Colors.white,
                    textStyle: CustomStyles.cardBoldDarkTextStyle,
                    height: 180,
                    cardNumber: cardNumber,
                    expiryDate: expiryDate,
                    cardHolderName: cardHolderName,
                    cvvCode: cvvCode,
                    showBackView: isCvvFocused,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: CreditCardForm(
                        cardHolderName: ',',
                        expiryDate: '',
                        cardNumber: '',
                        cvvCode: '',
                        /**The argument type 'String' can't be assigned to the parameter type 'GlobalKey<FormState>'.  */
                        formKey: formKey,
                        onCreditCardModelChange: onCreditCardModelChange,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 50.0,
            left: 0.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                MaterialButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  color: Colors.white,
                  textColor: Colors.green,
                  child: Icon(Icons.arrow_back, size: 15),
                  padding: EdgeInsets.all(6),
                  shape: CircleBorder(),
                ),
                Text("Add New Card", style: CustomStyles.cardBoldTextStyle),
              ],
            ),
          ),
          Positioned(
            top: 50.0,
            right: 0,
            child: MaterialButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              color: Colors.white,
              textColor: Colors.green,
              child: Icon(Icons.save, size: 20),
              padding: EdgeInsets.all(6),
              shape: CircleBorder(),
            ),
          ),
        ],
      ),
    );
  }
}
