import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../utils/UserSimplePreferences.dart';

part 'authentication_event.dart';

part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc() : super(AuthenticationLoadingState()) {
    on<CheckAuthenticationEvent>(_checkAuthentication);
    _init();
  }

  void _init() async {
    await UserSimplePreferences.init();
    // await Future.delayed(Duration(seconds: 1));
    add(CheckAuthenticationEvent());
  }

  FutureOr<void> _checkAuthentication(CheckAuthenticationEvent event,
      Emitter<AuthenticationState> emit) async {
    final isLoggedIn = UserSimplePreferences.getIsLoggedIn();
    if (isLoggedIn) {
      emit(AuthenticationLoadedState());
    }else{
      emit(AuthenticationEmptyState());
    }
  }
}
