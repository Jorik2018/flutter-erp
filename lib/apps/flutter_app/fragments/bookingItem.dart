import 'package:flutter/material.dart';
import 'package:flutter_erp/apps/flutter_app/models/trip_model.dart';
import 'package:flutter_erp/apps/flutter_app/verticaldivider.dart';


void main() {
  //debugPaintSizeEnabled = true;
  runApp( BookingFragment());
}

TripInfo tripInfo =  TripInfo();

class BookingFragment extends StatefulWidget {
  static const img =
      "https://flutter.io/tutorials/layout/images/card-flutter-gallery.png";
  static const String routeName = '/material/cards';

  @override
  Booking createState() =>  Booking();
}




class Booking extends State<BookingFragment> {

  ShapeBorder? _shape;

  static const double height = 366.0;
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextStyle titleStyle =
        theme.textTheme.headlineMedium!.copyWith(color: Colors.white);
    final TextStyle descriptionStyle = theme.textTheme.titleMedium!;
    return  Scaffold(
        body:  SafeArea(
            top: false,
            bottom: false,
            child:  Container(
                padding: const EdgeInsets.all(8.0),
                height: height,
                child:  Card(
                    shape: _shape,
                    child:  Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          // photo and title
                           SizedBox(
                            child:  Stack(
                              children: <Widget>[
                                buildProfileItem(
                                    "location", "name", "completed")
                              ],
                            ),
                          ),
                           Divider(),
                           Expanded(
                            child: tripItem(),
                          )
                          // description and share/explore buttons
                        ])))));
  }

  Container tripItem() {
    return  Container(
        padding: EdgeInsets.all(4.0),
        child:  Column(children: <Widget>[
          //region fare
           Row(children: <Widget>[
             Expanded(
              child:  Text("Fare"),
            ),
             Row(children: <Widget>[
               Container(
                  padding: EdgeInsets.only(right: 8.0),
                  child:  Text("2.9") // Text(t.payBy),
                  ),
               Text("2.0")
            ])
          ]),
          //endregion
          //region book
           Row(children: <Widget>[
             Expanded(
              child:  Text("Booking Id"),
            ),
             Column(children: <Widget>[
               Text("tafgasg"),
            ]),
          ]),
          //endregion
          //region class
           Row(children: <Widget>[
             Expanded(
              child:  Text("Class"),
            ),
             Column(children: <Widget>[
               Text("Economy"),
            ]),
          ]),
          //endregion
          //region pickup
           Row(children: <Widget>[
             Column(children: <Widget>[
               
               Icon(Icons.send),
               Icon(Icons.send),
            ]),
               Expanded(
                  
                  child:  DefaultTextStyle(
                    softWrap: false,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium!,
                    child:  Column(
                  children: <Widget>[
    
                      Column(
                         crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                         Text(
                          "Pickup",
                          style:  TextStyle(
                            color: Colors.grey[500],
                          ),
                        ),
                         Container(
                          child:  Text(
                            "Le Centre",
                            style:  TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    
        
                     Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                         Text(
                          "Destination",
                          style:  TextStyle(
                            color: Colors.grey[500],
                          ),
                        ),
                         Container(
                          child:  Text(
                            "Louis vuitton foundation",
                            style:  TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    )
                  ]),
          
              )),
              ]),

          
         Expanded(
          child:  Column(
            children: <Widget>[
                     Text(
                          "Driver note",
                          style:  TextStyle(
                            color: Colors.grey[500],
                          ),
                        ),
                         Container(
                          child:  Text(
                            "In Front of restaurant",
                            style:  TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        )
            ],
          ),
        )
        ])
            ,
    
    );
  }

  Container buildProfileItem(String location, String name, String completed) {
    const img =
        "https://flutter.io/tutorials/layout/images/card-flutter-gallery.png";

    return  Container(
        padding: const EdgeInsets.all(25.0),
        child:  Row(children: [
           Column(children: [
             Container(
                padding: EdgeInsets.fromLTRB(0.0, 0.0, 20.0, 0.0),
                child:  CircleAvatar(
                  backgroundImage: NetworkImage(img),
                ))
          ]),
           Expanded(
            child:  Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 Container(
                  child:  Text(
                    location,
                    style:  TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                 Text(
                  name,
                  style:  TextStyle(
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
           Column(children: [
             Container(
              decoration:  BoxDecoration(
                color: Colors.black45,
              ),
              child:  Text(
                completed,
                style:  TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            )
          ])
        ]));
  }
}
