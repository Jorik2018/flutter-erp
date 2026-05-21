import 'package:flutter/material.dart';
import 'package:flutter_erp/apps/flutter_crud_api_sample_app/api/api_service.dart';
import 'package:flutter_erp/apps/flutter_crud_api_sample_app/model/profile.dart';
import 'package:flutter_erp/apps/flutter_crud_api_sample_app/ui/formadd/form_add_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  ApiService? apiService;

  @override
  void initState() {
    super.initState();
    apiService = ApiService();
  }

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: FutureBuilder<List<Profile>?>(
        future: apiService!.getProfiles(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          if (snapshot.connectionState == ConnectionState.done) {
            final profiles = snapshot.data ?? [];
            return _buildListView(profiles);
          }

          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildListView(List<Profile> profiles) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: ListView.builder(
        itemBuilder: (context, index) {
          Profile profile = profiles[index];
          return Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      profile.name!,
                      //,style: Theme.of(context).textTheme.title,
                    ),
                    Text(profile.email!),
                    Text(profile.age.toString()),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        TextButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text("Warning"),
                                  content: Text(
                                    "Are you sure want to delete data profile ${profile.name}?",
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      child: Text("Yes"),
                                      onPressed: () {
                                        Navigator.pop(context);
                                        apiService!
                                            .deleteProfile(profile.id)
                                            .then((isSuccess) {
                                              if (isSuccess) {
                                                setState(() {});
                                                ScaffoldMessenger.of(
                                                  context,
                                                ).showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                      "Delete data success",
                                                    ),
                                                  ),
                                                );
                                              } else {
                                                ScaffoldMessenger.of(
                                                  context,
                                                ).showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                      "Delete data failed",
                                                    ),
                                                  ),
                                                );
                                              }
                                            });
                                      },
                                    ),
                                    TextButton(
                                      child: Text("No"),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Text(
                            "Delete",
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            var result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return FormAddScreen(profile: profile);
                                },
                              ),
                            );
                            if (result != null) {
                              setState(() {});
                            }
                          },
                          child: Text(
                            "Edit",
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        itemCount: profiles.length,
      ),
    );
  }
}
