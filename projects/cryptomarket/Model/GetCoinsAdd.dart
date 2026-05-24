class GetCoinsAdd {
  CoinInfo1 coinInfo;

  Display1 display;

  GetCoinsAdd(this.coinInfo, this.display);

  Map<String, dynamic> toMap() {
    return {'CoinInfo': coinInfo.toMap(), 'DISPLAY': display.toMap()};
  }

  GetCoinsAdd.fromMap(Map<String, dynamic> map)
    : coinInfo = CoinInfo1.fromMap(map['CoinInfo']),
      display = Display1.fromMap(map['DISPLAY']);
}

class CoinInfo1 {
  String fullName;
  String name;
  String imageUrl;

  CoinInfo1(this.fullName, this.name, this.imageUrl);

  Map<String, dynamic> toMap() {
    return {'FullName': fullName, 'Name': name, 'ImageUrl': imageUrl};
  }

  CoinInfo1.fromMap(Map<String, dynamic> map)
    : fullName = map['FullName'] ?? '',
      name = map['Name'] ?? '',
      imageUrl = map['ImageUrl'] ?? '';
}

class Display1 {
  String currency;
  USD1 usd;

  Display1(this.currency, this.usd);

  Map<String, dynamic> toMap() {
    return {
      /**The method 'toMap' isn't defined for the type 'USD1'.
Try correcting the name to the name of an existing method, or defining a method named 'toMap' */
      currency: usd.toMap(), // 👈 dinámico
    };
  }

  Display1.fromMap(Map<String, dynamic> map)
    : currency = map.keys.first,
      usd = USD1.fromMap(map.values.first);
}

class USD1 {
  String price;
  String changePct24Hour;
  String market;
  String change24Hour;
  String high24Hour;
  String low24Hour;
  String mktCap;
  String volume24Hour;
  String volume24HourTo;
  String toSymbol;
  String supply;

  USD1(
    this.price,
    this.changePct24Hour,
    this.market,
    this.change24Hour,
    this.high24Hour,
    this.low24Hour,
    this.mktCap,
    this.volume24Hour,
    this.volume24HourTo,
    this.toSymbol,
    this.supply,
  );

  Map<String, dynamic> toMap() {
    return {
      'PRICE': price,
      'CHANGEPCT24HOUR': changePct24Hour,
      'MARKET': market,
      'CHANGE24HOUR': change24Hour,
      'HIGH24HOUR': high24Hour,
      'LOW24HOUR': low24Hour,
      'MKTCAP': mktCap,
      'VOLUME24HOUR': volume24Hour,
      'VOLUME24HOURTO': volume24HourTo,
      'TOSYMBOL': toSymbol,
      'SUPPLY': supply,
    };
  }

  USD1.fromMap(Map<String, dynamic> map)
    : price = map['PRICE']?.toString() ?? '',
      changePct24Hour = map['CHANGEPCT24HOUR']?.toString() ?? '',
      market = map['MARKET']?.toString() ?? '',
      change24Hour = map['CHANGE24HOUR']?.toString() ?? '',
      high24Hour = map['HIGH24HOUR']?.toString() ?? '',
      low24Hour = map['LOW24HOUR']?.toString() ?? '',
      mktCap = map['MKTCAP']?.toString() ?? '',
      volume24Hour = map['VOLUME24HOUR']?.toString() ?? '',
      volume24HourTo = map['VOLUME24HOURTO']?.toString() ?? '',
      toSymbol = map['TOSYMBOL']?.toString() ?? '',
      supply = map['SUPPLY']?.toString() ?? '';
}

abstract class CryptoRepository {
  Future<List<GetCoinsAdd>> fetchCurrencies();
}
