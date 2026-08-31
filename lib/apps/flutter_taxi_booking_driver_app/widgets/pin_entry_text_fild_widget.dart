import 'package:flutter/material.dart';

class PinEntryTextField extends StatefulWidget {
  final String? lastPin;
  final int fields;
  final ValueChanged<String>? onSubmit;
  final double fontSize;
  final bool isTextObscure;
  final bool showFieldAsBox;

  const PinEntryTextField({
    super.key,
    this.lastPin,
    this.fields = 4,
    this.onSubmit,
    this.fontSize = 36.0,
    this.isTextObscure = false,
    this.showFieldAsBox = false,
  }) : assert(fields > 0);

  @override
  State<PinEntryTextField> createState() => PinEntryTextFieldState();
}

class PinEntryTextFieldState extends State<PinEntryTextField> {
  late List<String> _pin;
  late List<FocusNode> _focusNodes;
  late List<TextEditingController> _textControllers;

  Widget textfields = const SizedBox.shrink();

  @override
  void initState() {
    super.initState();

    _pin = List<String>.filled(widget.fields, '');

    _focusNodes = List<FocusNode>.generate(widget.fields, (_) => FocusNode());

    _textControllers = List<TextEditingController>.generate(
      widget.fields,
      (_) => TextEditingController(),
    );

    final lastPin = widget.lastPin;

    if (lastPin != null && lastPin.isNotEmpty) {
      final length = lastPin.length < widget.fields
          ? lastPin.length
          : widget.fields;

      for (var i = 0; i < length; i++) {
        _pin[i] = lastPin[i];
        _textControllers[i].text = lastPin[i];
      }
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      setState(() {
        textfields = generateTextFields(context);
      });
    });
  }

  @override
  void dispose() {
    for (final controller in _textControllers) {
      controller.dispose();
    }

    for (final focusNode in _focusNodes) {
      focusNode.dispose();
    }

    super.dispose();
  }

  Widget generateTextFields(BuildContext context) {
    final textFields = List<Widget>.generate(
      widget.fields,
      (int i) => buildTextField(i, context),
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      verticalDirection: VerticalDirection.down,
      children: textFields,
    );
  }

  void clearTextFields() {
    for (final controller in _textControllers) {
      controller.clear();
    }

    for (var i = 0; i < _pin.length; i++) {
      _pin[i] = '';
    }
  }

  Widget buildTextField(int i, BuildContext context) {
    return Container(
      width: 68,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const Color(0XFFF1F3F7),
      ),
      margin: const EdgeInsets.all(8),
      child: TextField(
        showCursor: false,
        controller: _textControllers[i],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        obscureText: widget.isTextObscure,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black,
          fontSize: widget.fontSize,
        ),
        focusNode: _focusNodes[i],
        decoration: InputDecoration(
          border: InputBorder.none,
          counterText: "",
          hintText: "•",
          hintStyle: TextStyle(fontSize: widget.fontSize),
        ),
        onChanged: (String str) {
          setState(() {
            _pin[i] = str;
          });

          if (str.isEmpty) {
            if (i > 0) {
              _focusNodes[i].unfocus();
              FocusScope.of(context).requestFocus(_focusNodes[i - 1]);
            }
          } else {
            if (i < widget.fields - 1) {
              _focusNodes[i].unfocus();
              FocusScope.of(context).requestFocus(_focusNodes[i + 1]);
            } else {
              _focusNodes[i].unfocus();
            }
          }

          if (_pin.every((digit) => digit.isNotEmpty)) {
            widget.onSubmit?.call(_pin.join());
          }
        },
        onSubmitted: (String str) {
          if (_pin.every((digit) => digit.isNotEmpty)) {
            widget.onSubmit?.call(_pin.join());
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return textfields;
  }
}
