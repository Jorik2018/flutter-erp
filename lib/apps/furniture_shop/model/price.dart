class Price {

  final double? mrp;
  
  final String? currency;

  Price({this.mrp, this.currency});

  String get representablePrice => '$currency$mrp';
}
