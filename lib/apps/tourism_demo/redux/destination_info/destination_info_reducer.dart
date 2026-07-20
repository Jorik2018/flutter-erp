import 'package:redux/redux.dart';
import 'package:flutter_erp/apps/tourism_demo/redux/destination_info/destination_info_actions.dart';
import 'package:flutter_erp/apps/tourism_demo/redux/destination_info/destination_info_state.dart';

final destinationInfoReducer = combineReducers<DestinationInfoState>([
  TypedReducer<DestinationInfoState, SelectedDestinationAction>(
    _changeSelectedCard,
  ),
]);

DestinationInfoState _changeSelectedCard(
  DestinationInfoState destinationInfoState,
  SelectedDestinationAction action,
) {
  return destinationInfoState.copyWith(destinationCard: action.destinationCard);
}
