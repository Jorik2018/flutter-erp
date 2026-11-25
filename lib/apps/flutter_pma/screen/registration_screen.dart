import 'package:flutter/material.dart';
import 'package:flutter_erp/apps/flutter_pma/utils/navigation_router.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Registration')),
      body: Container(
        padding: EdgeInsets.all(20.0),

        child: Form(
          child: ListView(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[FlutterLogo(size: 100.0)],
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 10.0),
                child: TextFormField(
                  keyboardType:
                      TextInputType.text, // Use email input type for emails.
                  decoration: InputDecoration(
                    hintText: 'User Name',
                    labelText: 'Enter your user name',
                    icon: Icon(Icons.person),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 10.0),
                child: TextFormField(
                  keyboardType: TextInputType
                      .emailAddress, // Use email input type for emails.
                  decoration: InputDecoration(
                    hintText: 'you@example.com',
                    labelText: 'E-mail Address',
                    icon: Icon(Icons.email),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 10.0),
                child: TextFormField(
                  obscureText: true, // Use secure text for passwords.
                  decoration: InputDecoration(
                    hintText: 'Password',
                    labelText: 'Enter your password',
                    icon: Icon(Icons.lock),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 10.0),
                child: TextFormField(
                  obscureText: true, // Use secure text for passwords.
                  decoration: InputDecoration(
                    hintText: 'Confirm Password',
                    labelText: 'Enter your confirm password',
                    icon: Icon(Icons.lock),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height: 50.0,
                    width: 210.0,
                    margin: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 40.0,
                    ),
                    child: ElevatedButton(
                      child: Text(
                        'Register',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () => _performLogin(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  _performLogin() {}

  _navigateRegistration() {
    NavigationRouter.switchToRegistration(context);
  }
}
