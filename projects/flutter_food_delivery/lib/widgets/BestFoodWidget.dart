import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class BestFoodWidget extends StatefulWidget {
  @override
  _BestFoodWidgetState createState() => _BestFoodWidgetState();
}

class _BestFoodWidgetState extends State<BestFoodWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      width: double.infinity,
      child: Column(
        children: <Widget>[
          BestFoodTitle(),
          Expanded(
            child: BestFoodList(),
          )
        ],
      ),
    );
  }
}

class BestFoodTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            "Best Foods",
            style: TextStyle(
                fontSize: 20,
                color: Color(0xFF3a3a3b),
                fontWeight: FontWeight.w300),
          ),
        ],
      ),
    );
  }
}

class BestFoodTiles extends StatelessWidget {
  String? name;
  String? imageUrl;
  String? rating;
  String? numberOfRating;
  String? price;
  String? slug;

  BestFoodTiles(
      {Key? key,
      @required this.name,
      @required this.imageUrl,
      @required this.rating,
      @required this.numberOfRating,
      @required this.price,
      @required this.slug})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {

  _bottomSheet(context,
                        image:'ic_best_food_1.jpeg',// popularItems[index].image!,
                        title: 'popularItems[index].title!',
                        rating: 2.5//popularItems[index].rating!.toDouble());
  );
      },
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 10, right: 5, top: 5, bottom: 5),
            decoration: BoxDecoration(boxShadow: [
              /* BoxShadow(
                color: Color(0xFFfae3e2),
                blurRadius: 15.0,
                offset: Offset(0, 0.75),
              ),*/
            ]),
            child: Card(
              semanticContainer: true,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: Image.asset(
                'assets/images/bestfood/' + imageUrl! + ".jpeg",
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 1,
              margin: EdgeInsets.all(5),
            ),
          ),
        ],
      ),
    );
  }



  void _bottomSheet(BuildContext context,{ String? image,String? title,double? rating}) {
    showModalBottomSheet(backgroundColor: Colors.transparent,context: context, builder: (builder) {
      return Container(
        height: 400,
        padding: EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
            color: Colors.white,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(15),topRight: Radius.circular(15))
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              alignment: Alignment.center,
              height: 180,
              child: Stack(
                children: [
                  Align(alignment: Alignment.center,child: Image.asset("assets/images/bestfood/ic_best_food_1.jpeg",fit: BoxFit.cover,)),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Icon(Icons.favorite_border),
                  )
                ],
              ),
            ),
            SizedBox(height: 8,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title!,style: TextStyle(fontSize: 18),),
                Text("\$31.00",style: TextStyle(color: Colors.deepOrange),),
              ],
            ),
            SizedBox(height: 8,),
            Row(
              children: [
                RatingBar.builder(
                  initialRating: rating!,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemSize: 18,
                  itemBuilder: (context, _) =>
                      Icon(
                        Icons.star,
                        size: 18,
                        color: Colors.deepOrange,
                      ),
                  itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
                  onRatingUpdate: (double value) {},
                ),
                Text("90 Rating"),
              ],
            ),
            Text("About $title",style: TextStyle(fontSize: 16),),
            Text("Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took ",textAlign: TextAlign.start,),
            SizedBox(height: 15,),
            InkWell(
              onTap: (){
                Navigator.pop(context);
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 8),
                width: double.infinity,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.deepOrange,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Text("Add To Order",style: TextStyle(fontSize: 18,color: Colors.white),),
              ),
            ),
          ],
        ),
      );
    });
  }


}

class BestFoodList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        BestFoodTiles(
            name: "Fried Egg",
            imageUrl: "ic_best_food_8",
            rating: '4.9',
            numberOfRating: '200',
            price: '15.06',
            slug: "fried_egg"),
        BestFoodTiles(
            name: "Mixed vegetable",
            imageUrl: "ic_best_food_9",
            rating: "4.9",
            numberOfRating: "100",
            price: "17.03",
            slug: ""),
        BestFoodTiles(
            name: "Salad with chicken meat",
            imageUrl: "ic_best_food_10",
            rating: "4.0",
            numberOfRating: "50",
            price: "11.00",
            slug: ""),
        BestFoodTiles(
            name: "New mixed salad",
            imageUrl: "ic_best_food_5",
            rating: "4.00",
            numberOfRating: "100",
            price: "11.10",
            slug: ""),
        BestFoodTiles(
            name: "Red meat with salad",
            imageUrl: "ic_best_food_1",
            rating: "4.6",
            numberOfRating: "150",
            price: "12.00",
            slug: ""),
        BestFoodTiles(
            name: "New mixed salad",
            imageUrl: "ic_best_food_2",
            rating: "4.00",
            numberOfRating: "100",
            price: "11.10",
            slug: ""),
        BestFoodTiles(
            name: "Potato with meat fry",
            imageUrl: "ic_best_food_3",
            rating: "4.2",
            numberOfRating: "70",
            price: "23.0",
            slug: ""),
        BestFoodTiles(
            name: "Fried Egg",
            imageUrl: "ic_best_food_4",
            rating: '4.9',
            numberOfRating: '200',
            price: '15.06',
            slug: "fried_egg"),
        BestFoodTiles(
            name: "Red meat with salad",
            imageUrl: "ic_best_food_5",
            rating: "4.6",
            numberOfRating: "150",
            price: "12.00",
            slug: ""),
        BestFoodTiles(
            name: "Red meat with salad",
            imageUrl: "ic_best_food_6",
            rating: "4.6",
            numberOfRating: "150",
            price: "12.00",
            slug: ""),
        BestFoodTiles(
            name: "Red meat with salad",
            imageUrl: "ic_best_food_7",
            rating: "4.6",
            numberOfRating: "150",
            price: "12.00",
            slug: ""),
      ],
    );
  }
}
