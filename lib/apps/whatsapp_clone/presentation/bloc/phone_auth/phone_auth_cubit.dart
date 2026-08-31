import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_erp/models/user.dart' as app_user;
import 'package:flutter_erp/apps/whatsapp_clone/domain/usecases/get_create_current_user_usecase.dart';
import 'package:flutter_erp/apps/whatsapp_clone/domain/usecases/sign_in_with_phone_number_usecase.dart';
import 'package:flutter_erp/apps/whatsapp_clone/domain/usecases/verify_phone_number_usecase.dart';

part 'phone_auth_state.dart';

class PhoneAuthCubit extends Cubit<PhoneAuthState> {
  final SignInWithPhoneNumberUseCase signInWithPhoneNumberUseCase;
  final VerifyPhoneNumberUseCase verifyPhoneNumberUseCase;
  final GetCreateCurrentUserUseCase getCreateCurrentUserUseCase;

  PhoneAuthCubit({
    required this.signInWithPhoneNumberUseCase,
    required this.verifyPhoneNumberUseCase,
    required this.getCreateCurrentUserUseCase,
  }) : super(PhoneAuthInitial());

  Future<void> submitVerifyPhoneNumber({required String phoneNumber}) async {
    emit(PhoneAuthLoading());
    try {
      await verifyPhoneNumberUseCase.call(phoneNumber);
      emit(PhoneAuthSmsCodeReceived());
    } on SocketException catch (_) {
      emit(PhoneAuthFailure());
    } catch (_) {
      emit(PhoneAuthFailure());
    }
  }

  Future<void> submitSmsCode({required String smsCode}) async {
    emit(PhoneAuthLoading());
    try {
      await signInWithPhoneNumberUseCase.call(smsCode);
      emit(PhoneAuthProfileInfo());
    } on SocketException catch (_) {
      emit(PhoneAuthFailure());
    } catch (_) {
      emit(PhoneAuthFailure());
    }
  }

  Future<void> submitProfileInfo({
    required String name,
    required String profileUrl,
    required String phoneNumber,
  }) async {
    try {
      await getCreateCurrentUserUseCase.call(
        app_user.User(
          id: "",
          name: name,
          email: "",
          phoneNumber: phoneNumber,
          isLogged: true,
          photoUrl: profileUrl,
          status: "",
        ),
      );
      emit(PhoneAuthSuccess());
    } on SocketException catch (_) {
      emit(PhoneAuthFailure());
    } catch (_) {
      emit(PhoneAuthFailure());
    }
  }
}
