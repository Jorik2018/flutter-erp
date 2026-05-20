import 'package:flutter/material.dart';
import '../models/notification_model.dart';

class NotificationFragment extends StatefulWidget {
  @override
  NotificationState createState() {
    return NotificationState();
  }
}

class NotificationState extends State<NotificationFragment> {
  ShapeBorder? _shape;
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(8.0),
        height: 300.0,
        child: Card(
          shape: _shape,
          child: Align(
            alignment: Alignment.topCenter,
            child: 
              // photo and title
              ListView.builder(
                  itemCount: dummyData.length,
                  itemBuilder: (context, i) => Column(children: <Widget>[
                        Divider(
                          height: 10.0,
                        ),
                        ListTile(
                          leading: CircleAvatar(
                            foregroundColor: Theme.of(context).primaryColor,
                            backgroundColor: Colors.grey,
                            backgroundImage:
                                NetworkImage(dummyData[i].icon!),
                          ),
                          title: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  dummyData[i].title!,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold),
                                )
                              ]),
                          subtitle: Container(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: Text(
                              dummyData[i].title!,
                              style: TextStyle(
                                  color: Colors.grey, fontSize: 15.0),
                            ),
                          ),
                        )
                      ]))
            
          ),
          
        )
        );
  }
}
