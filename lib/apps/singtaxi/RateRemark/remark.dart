import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RemarkPage extends StatefulWidget {
  @override
  _RemarkPageState createState() => _RemarkPageState();
}

class _RemarkPageState extends State<RemarkPage> {
  var myFeedbackText = "COULD BE BETTER";
  var sliderValue = 0.0;
  IconData myFeedback1 = FontAwesomeIcons.star.data,
      myFeedback2 = FontAwesomeIcons.star.data,
      myFeedback3 = FontAwesomeIcons.star.data,
      myFeedback4 = FontAwesomeIcons.star.data,
      myFeedback5 = FontAwesomeIcons.star.data;
  Color myFeedbackColor1 = Colors.grey,
      myFeedbackColor2 = Colors.grey,
      myFeedbackColor3 = Colors.grey,
      myFeedbackColor4 = Colors.grey,
      myFeedbackColor5 = Colors.grey;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Remark'),
        backgroundColor: Colors.brown[600],
      ),
      body: Column(
        children: <Widget>[
          Container(
            color: Color(0xffE5E5E5),
            child: Column(
              children: <Widget>[
                Container(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      child: Text(
                        "On a scale of 1 to 5, how do you rate our driver?",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 50.0),
                Container(
                  child: Align(
                    child: Material(
                      color: Colors.white,
                      elevation: 14.0,
                      borderRadius: BorderRadius.circular(24.0),
                      shadowColor: Color(0x802196F3),
                      child: Container(
                        width: 350.0,
                        height: 430.0,
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Container(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: StarWidget(),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                child: Slider(
                                  min: 0.0,
                                  max: 5.0,
                                  divisions: 5,
                                  value: sliderValue,
                                  activeColor: Color(0xffcddc39),
                                  inactiveColor: Colors.yellowAccent,
                                  onChanged: (newValue) {
                                    setState(() {
                                      sliderValue = newValue;
                                      if (sliderValue == 1.0) {
                                        myFeedback1 =
                                            FontAwesomeIcons.solidStar.data;
                                        myFeedbackColor1 = Colors.green[100]!;
                                      } else if (sliderValue < 1.0) {
                                        myFeedback1 =
                                            FontAwesomeIcons.star.data;
                                        myFeedbackColor1 = Colors.grey;
                                      }
                                      if (sliderValue == 2.0) {
                                        myFeedback2 =
                                            FontAwesomeIcons.solidStar.data;
                                        myFeedbackColor2 = Colors.green[200]!;
                                      } else if (sliderValue < 2.0) {
                                        myFeedback2 =
                                            FontAwesomeIcons.star.data;
                                        myFeedbackColor2 = Colors.grey;
                                      }
                                      if (sliderValue == 3.0) {
                                        myFeedback3 =
                                            FontAwesomeIcons.solidStar.data;
                                        myFeedbackColor3 = Colors.green[300]!;
                                      } else if (sliderValue < 3.0) {
                                        myFeedback3 =
                                            FontAwesomeIcons.star.data;
                                        myFeedbackColor3 = Colors.grey;
                                      }
                                      if (sliderValue == 4.0) {
                                        myFeedback4 =
                                            FontAwesomeIcons.solidStar.data;
                                        myFeedbackColor4 = Colors.green[400]!;
                                      } else if (sliderValue < 4.0) {
                                        myFeedback4 =
                                            FontAwesomeIcons.star.data;
                                        myFeedbackColor4 = Colors.grey;
                                      }
                                      if (sliderValue == 5.0) {
                                        myFeedback5 =
                                            FontAwesomeIcons.solidStar.data;
                                        myFeedbackColor5 = Colors.green;
                                      } else if (sliderValue < 5.0) {
                                        myFeedback5 =
                                            FontAwesomeIcons.star.data;
                                        myFeedbackColor5 = Colors.grey;
                                      }
                                    });
                                  },
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Container(
                                child: Text(
                                  "Your Rating : $sliderValue",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 22.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Container(
                                child: TextField(
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.lightGreen,
                                      ),
                                    ),
                                    hintText: 'Add Comment',
                                  ),
                                  style: TextStyle(height: 3.0),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                child: Align(
                                  alignment: Alignment.bottomCenter,
                                  child: ElevatedButton(
                                    child: Text(
                                      'Submit',
                                      style: TextStyle(
                                        color: Color(0xffffffff),
                                      ),
                                    ),
                                    onPressed: () {
                                      print("Successful Rating");
                                      Navigator.of(
                                        context,
                                      ).pushReplacementNamed('/TripRate');
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> StarWidget() {
    List<Widget> myContainer = [];
    myContainer.add(
      Container(child: Icon(myFeedback1, color: myFeedbackColor1, size: 50.0)),
    );
    myContainer.add(
      Container(child: Icon(myFeedback2, color: myFeedbackColor2, size: 50.0)),
    );
    myContainer.add(
      Container(child: Icon(myFeedback3, color: myFeedbackColor3, size: 50.0)),
    );
    myContainer.add(
      Container(child: Icon(myFeedback4, color: myFeedbackColor4, size: 50.0)),
    );
    myContainer.add(
      Container(child: Icon(myFeedback5, color: myFeedbackColor5, size: 50.0)),
    );
    return myContainer;
  }
}
