import 'package:flutter/material.dart';
import 'package:flutter_erp/apps/flutter_todo/models/priority.dart';

class PriorityFormField extends FormField<Priority> {
  PriorityFormField({
    super.key,
    required FormFieldSetter<Priority> onSaved,
    Priority initialValue = Priority.Low,
  }) : super(
         onSaved: onSaved,
         initialValue: initialValue,
         builder: (FormFieldState<Priority> state) {
           return Row(
             children: Priority.values.map((priority) {
               final isSelected = state.value == priority;

               return Padding(
                 padding: const EdgeInsets.only(right: 8.0),
                 child: ChoiceChip(
                   label: Text(priority.name),
                   selected: isSelected,
                   onSelected: (_) {
                     state.didChange(priority);
                   },
                 ),
               );
             }).toList(),
           );
         },
       );
}
