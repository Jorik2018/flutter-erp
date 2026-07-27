import 'package:disposebag/disposebag.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:rxdart_ext/rxdart_ext.dart';

import '../../domain/contact.dart';
import '../../domain/contact_repository.dart';
import 'home_state.dart';

// ignore_for_file: close_sinks
/**Classes can only extend other classes.
Try specifying a different superclass, or removing the extends clause.dartextends_non_class */
class HomeBloc extends DisposeCallbackBaseBloc {
  /**Undefined class 'Func1'.
Try changing the name to the name of an existing class, or creating a class with the name 'Func1' */
  final Func1<String, void> search;

  final Func1<Contact, void> delete;

  final VoidAction deleteAll;

  final ValueStream<HomeState> state$;

  final Stream<HomeMessage> message$;

  HomeBloc._(
    this.deleteAll,
    this.search,
    this.delete,
    this.state$,
    this.message$,
    VoidAction dispose,
  ) : super(dispose);

  factory HomeBloc(final ContactRepository contactRepo) {
    final searchController = PublishSubject<String>();

    final deleteController = PublishSubject<Contact>();

    final deleteAllController = PublishSubject<void>();

    final state$ = searchController
        .debounceTime(const Duration(milliseconds: 500))
        .startWith('')
        .map((s) => s.trim())
        .distinct()
        .switchMap((s) => _performSearch(contactRepo, s))
        .shareValueSeeded(
          HomeState(
            (b) => b
              ..contacts.replace([])
              ..isLoading = true
              ..error = null,
          ),
        );

    final message$ = deleteController
        .flatMap(
          (contact) => Rx.fromCallable(
            () => contactRepo.delete(contact),
          ).onErrorReturn(false),
        )
        .map(
          (success) => success
              ? const DeleteContactSuccess()
              : const DeleteContactFailure(),
        )
        .publish();

    final bag = DisposeBag([
      deleteAllController
          .exhaustMap((_) => Rx.fromCallable(contactRepo.deleteAll))
          .debug(identifier: '[HOME_BLOC] deteteAll')
          .collect(),
      //
      message$.debug(identifier: '[HOME_BLOC] message').collect(),
      message$.connect(),
      //
      state$.debug(identifier: '[HOME_BLOC] state').collect(),
      //state$.connect(),
      //
      deleteAllController,
      searchController,
      deleteController,
    ], 'HomeBloc');

    return HomeBloc._(
      () => deleteAllController.add(null),
      searchController.add,
      deleteController.add,
      state$,
      message$,
      bag.dispose,
    );
  }

  static Stream<HomeState> _performSearch(
    ContactRepository contactRepo,
    String query,
  ) {
    return contactRepo
        .search(by: query)
        .map(
          (contacts) => HomeState(
            (b) => b
              ..contacts.replace(contacts)
              ..isLoading = false,
          ),
        )
        /*.onErrorReturnWith(
          (e) => HomeState((b) => b
            ..error = e
            ..isLoading = false),
        )*/
        .startWith(HomeState((b) => b.isLoading = true));
  }
}
