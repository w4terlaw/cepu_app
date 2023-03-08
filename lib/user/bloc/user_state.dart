part of 'user_bloc.dart';

@immutable
abstract class UserState {}

class UserInitial extends UserState {}

class UserLoadingState extends UserState {}

class UserLoadedState extends UserState {
  // final User userInfo;
  //
  // UserLoadedState(this.userInfo);
}

// class User {
//   final String displayName;
//   final String id;
//   final String email;
//   final String photoUrl;
//
//   User({required this.displayName, required this.id, required this.email, required this.photoUrl});
//
//   @override
//   String toString() {
//     return "($displayName,$id, $email, $photoUrl)";
//   }
// }
