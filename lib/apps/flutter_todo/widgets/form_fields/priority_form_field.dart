import 'package:flutter/material.dart';

import 'package:flutter_erp/apps/flutter_todo/models/priority.dart';

class PriorityFormField extends FormField<Priority> {
  PriorityFormField({
    required FormFieldSetter<Priority> onSaved,
    Priority initialValue = Priority.Low,
  }) : super(
         onSaved: onSaved,
         initialValue: initialValue,
         builder: (FormFieldState<Priority> state) {
           return Row(
             children: Priority.values
                 .map(
                   (priority) => Container(
                     height: 60.0,
                     child: state.value == priority
                         ? TextButton(
                             child: Icon(Icons.check),
                             onPressed: () {
                               state.didChange(priority);
                             },
                           )
                         : Text(''),
                   ),
                 )
                 .toList(),
           );
         },
       );
}
