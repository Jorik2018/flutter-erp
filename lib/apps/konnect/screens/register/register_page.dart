import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_erp/apps/konnect/sevices/auth.dart';
import 'package:flutter_erp/apps/konnect/utils/colors.dart';
import 'package:flutter_erp/apps/konnect/utils/dimensions.dart';
import 'package:flutter_erp/apps/konnect/validators/form_validator.dart';
import 'package:flutter_erp/apps/konnect/widgets/image_input.dart';
import 'package:provider/provider.dart';
// import 'package:flutter_erp/apps/konnect/widgets/toast_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

/**Missing concrete implementations of 'getter FormValidator.emailError', 'getter FormValidator.emailValidator', 'getter FormValidator.emptyname', 'getter FormValidator.nonEmptyTextValidator', and 6 more.
Try implementing the missing methods, or make the class abstract. */
class RegisterPage extends StatefulWidget {
  final User userToRegister;
  RegisterPage(this.userToRegister);
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> with FormValidator {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

  final bool _isSubmitted = false;
  File? _pickedImage;
  int _gender = 0;
  late Dimensions myDim;

  bool get canSubmit => name != null;
  void _selectImage(File pickedImage) {
    setState(() {
      _pickedImage = pickedImage;
    });
  }

  // ToastWidget _toast;
  // @override
  // void initState() {
  //   super.initState();
  //   _toast = ToastWidget();
  // }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _emailController.dispose();
  }

  String get name => _nameController.text.trim();

  String? get nameErrorText {
    final bool showErrorText =
        _isSubmitted && !nonEmptyTextValidator.isValid(_nameController.text);

    return showErrorText ? emptyname : null;
  }

  late AuthBase auth;
  @override
  Widget build(BuildContext context) {
    auth = Provider.of<AuthBase>(context, listen: false);
    myDim = Dimensions(context);
    const spaceBox = SizedBox(height: 10.0);
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 20.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    text: 'Konnect',
                    style: Theme.of(
                      context,
                    ).textTheme.headlineLarge!.copyWith(color: kColorPrimary),
                    children: <TextSpan>[
                      TextSpan(
                        text: ' better.\nAnytime. Anywhere.',
                        style: Theme.of(context).textTheme.headlineLarge!,
                      ),
                    ],
                  ),
                ),
                spaceBox,
                spaceBox,
                Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 16.0),
                  child: Center(
                    child: ImageInput(_selectImage, InputType.profile),
                  ),
                ),
                spaceBox,
                _buildCustomTextField(
                  controller: _nameController,
                  prefix: Icons.person_outline,
                  label: 'Name',
                  hint: '',
                  inputType: TextInputType.name,
                  errorText: nameErrorText,
                  textCapitals: TextCapitalization.words,
                  shiftFocusTo: null,
                ),
                spaceBox,
                spaceBox,
                _buildGenderRadios(),
                spaceBox,
                _buildSubmitButton(),
                spaceBox,
                Text(
                  'Filling up the details accurately will help us ensure an easy connection to your favorites.',
                  textAlign: TextAlign.center,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall!.copyWith(color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCustomTextField({
    TextEditingController? controller,
    FocusNode? myFocus,
    required IconData prefix,
    String? label,
    String? hint,
    TextInputType? inputType,
    required TextCapitalization textCapitals,
    String? errorText,
    FocusNode? shiftFocusTo,
  }) {
    return TextField(
      focusNode: myFocus,
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: Icon(prefix),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: kColorPrimary),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
        ),
        labelText: label,
        hintText: hint,
        errorText: errorText,
      ),
      autocorrect: false,
      textCapitalization: textCapitals,
      keyboardType: inputType,
      textInputAction: TextInputAction.next,
      onChanged: (val) {
        setState(() {});
      },
      onEditingComplete: () {
        shiftFocusTo == null
            ? _submit()
            : FocusScope.of(context).requestFocus(shiftFocusTo);
      },
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _submit,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) => kColorPrimary,
          ),
          shape: MaterialStateProperty.resolveWith<OutlinedBorder>(
            (Set<MaterialState> states) => RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(7.0),
              side: BorderSide(color: Colors.transparent),
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Text('Submit'),
        ),
      ),
    );
  }

  void _submit() async {
    await auth.signOut();
    //User thisUser = widget.userToRegister;
    // Konnector registeredUser = Konnector(
    //     id: thisUser.uid,
    //     name: name,
    //     email: thisUser.email,
    //     phoneNo: thisUser.phoneNumber,
    //     gender: _gender==0?'M':'F',
    //     photoUrl: '');
    // CollectionReference users = FirebaseFirestore.instance.collection('users');
    // await users.doc(registeredUser.id).set({
    //   'id': registeredUser.id,
    //   'name': registeredUser.name,
    //   'email': registeredUser.email,
    //   'phoneNo': registeredUser.phoneNo
    // });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('user', 'user');
    Navigator.of(context).pop();
  }

  Widget _buildGenderRadios() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Select your Gender'),

        RadioGroup<int>(
          groupValue: _gender,
          onChanged: (value) {
            if (value != null) {
              _setValue(value);
            }
          },
          child: Row(
            children: [
              SizedBox(
                width: myDim.width * 0.4,
                child: const RadioListTile<int>(
                  activeColor: kColorPrimary,
                  title: Text('Male'),
                  value: 0,
                ),
              ),
              SizedBox(
                width: myDim.width * 0.4,
                child: const RadioListTile<int>(
                  activeColor: kColorPrimary,
                  title: Text('Female'),
                  value: 1,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _setValue(int value) => setState(() => _gender = value);
}
