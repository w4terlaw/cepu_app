part of 'authentication_bloc.dart';

@immutable
abstract class AuthenticationState {}

class AuthenticationLoadingState extends AuthenticationState {}

class AuthenticationLoadedState extends AuthenticationState {}

class AuthenticationEmptyState extends AuthenticationState {}
