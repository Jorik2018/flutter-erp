import 'package:flutter/material.dart';
import '../../classes/cart.dart';
import '../../classes/plants_list.dart';
import 'cart_item.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => new _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    if (Cart.cartItems.length > 0) {
      return new Material(
        borderRadius: BorderRadius.circular(8.0),
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0.0,
            automaticallyImplyLeading: false,
            title: Text(
              'Shopping cart',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w700,
                fontSize: 26.0,
              ),
            ),
            actions: <Widget>[
              new Center(
                child: IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(Icons.close, color: Colors.black45),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.white,
          body: ListView.builder(
            itemCount: Cart.cartItems.length,
            itemBuilder: (_, int pos) =>
                new CartItem(plantsList[Cart.cartItems[pos]]),
          ),
          bottomNavigationBar: Hero(
            tag: 'Buy button',
            child: MaterialButton(
              onPressed: () {},
              color: Colors.green,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Text(
                  'Buy Now (\$${calculateFinalPrice().toStringAsFixed(2)})',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    } else // Show an empty state
    {
      return new Material(
        borderRadius: BorderRadius.circular(8.0),
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0.0,
            automaticallyImplyLeading: false,
            title: Text(
              'Shopping cart',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w700,
                fontSize: 26.0,
              ),
            ),
            actions: <Widget>[
              new Center(
                child: IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(Icons.close, color: Colors.black45),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.white,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                new Icon(
                  Icons.remove_shopping_cart,
                  color: Colors.black26,
                  size: 96.0,
                ),
                new Padding(padding: EdgeInsets.only(bottom: 48.0)),
                new Text(
                  'Your cart is empty!',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                    fontSize: 28.0,
                  ),
                ),
                new Padding(padding: EdgeInsets.only(bottom: 8.0)),
                new Container(
                  margin: EdgeInsets.symmetric(horizontal: 64.0),
                  child: Text(
                    'Looks like you haven\'t added any plants to your cart yet.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20.0),
                  ),
                ),
                new Padding(padding: EdgeInsets.only(bottom: 96.0)),
                new Container(
                  child: Material(
                    elevation: 16.0,
                    shadowColor: Color(0x7000E676),
                    color: Colors.white,
                    child: InkWell(
                      onTap: () => Navigator.of(context).pop(),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 64.0,
                          vertical: 16.0,
                        ),
                        child: Text(
                          'Go back',
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }

  double calculateFinalPrice() {
    double cost = 0.0;
    for (int plantPos in Cart.cartItems) {
      cost += plantsList[plantPos].price;
    }

    return cost;
  }
}
