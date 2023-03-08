import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../authentication/authentication.dart';
import 'home/home.dart';
import 'login/login.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (BuildContext context, child) => const MaterialApp(
        // debugShowCheckedModeBanner: false,
        home: AppView(),
      ),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authBloc = AuthenticationBloc();
    return BlocProvider(
      create: (_) => authBloc,
      child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        bloc: authBloc,
        builder: (context, state) {
          if (state is AuthenticationLoadedState) {
            return const Home();
          } else if (state is AuthenticationEmptyState) {
            return const Login();
          } else {
            return Container(
                color: Colors.white,
                child: const Center(child: CircularProgressIndicator()));
          }
        },
      ),
    );
  }
}
