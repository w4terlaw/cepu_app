import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

import '../../api/GetUserFromApi.dart';
import '../../api/google/GoogleSignInApi.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(UserInitial()) {
    on<UserGetEvent>(_onGetUser);
  }

  FutureOr<void> _onGetUser(UserGetEvent event, Emitter<UserState> emit) async {
    final user = await GoogleSignInApi.login();
    await GoogleSignInApi.logout();
    emit(UserLoadingState());
    await userFromApi(user);
    emit(UserLoadedState());
  }
}
