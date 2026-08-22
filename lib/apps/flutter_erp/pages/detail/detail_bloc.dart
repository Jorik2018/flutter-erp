import 'package:disposebag/disposebag.dart';
import 'package:rxdart_ext/rxdart_ext.dart';

import '../../domain/contact.dart';
import '../../domain/contact_repository.dart';

class DetailBloc {
  final ValueStream<Contact?> contact$;

  final void Function() _dispose;

  DetailBloc._(this.contact$, this._dispose);

  factory DetailBloc(ContactRepository contactRepo, Contact initial) {
    final id = initial.id;

    if (id == null) {
      throw ArgumentError('Contact id must not be null');
    }

    final contact$ = contactRepo.getContactById(id).publishValue();

    final bag = DisposeBag([
      contact$.debug(identifier: '[DETAIL_BLOC] contact').collect(),
      contact$.connect(),
    ], 'DetailBloc');

    return DetailBloc._(contact$, bag.dispose);
  }

  void dispose() {
    _dispose();
  }
}
