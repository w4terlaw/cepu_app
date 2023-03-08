import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../user/user.dart';
import '../../home/home.dart';


class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: _buildWidget(),
      ),
    );
  }

  Widget _buildWidget() {
    final userBloc = UserBloc();
    return BlocProvider<UserBloc>(
      create: (context) => userBloc,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'CEPUqr',
                    style: TextStyle(
                        fontFamily: 'Rubik',
                        fontWeight: FontWeight.bold,
                        fontSize: 40,
                        color: Colors.grey),
                  ),
                  const Padding(padding: EdgeInsets.only(top: 50)),
                  BlocListener<UserBloc, UserState>(
                    listener: (context, state) {
                      if (state is UserLoadingState) {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return const Center(
                                child: SizedBox(
                                    width: 40,
                                    height: 40,
                                    child: CircularProgressIndicator(
                                      color: Colors.black,
                                    )),
                              );
                            });
                      }
                      if (state is UserLoadedState) {
                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                const Home()));
                      }
                    },
                    child: OutlinedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              const Color.fromRGBO(234, 232, 232, 1.0)),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40),
                            ),
                          ),
                          side: MaterialStateProperty.all(const BorderSide(
                              color: Color.fromRGBO(234, 232, 232, 1.0),
                              width: 1.0,
                              style: BorderStyle.solid))),
                      onPressed: () {
                        userBloc.add(UserGetEvent());
                      },
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          // mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            CircleAvatar(
                              backgroundImage:
                              AssetImage("assets/images/google_logo.png"),
                              radius: 15,
                            ),
                            // Image(
                            //   image: AssetImage("assets/images/google_logo.png"),
                            //   height: 40.0,
                            // ),
                            Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: Text(
                                'Войти через Google',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'Rubik',
                                  color: Colors.black,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const Padding(padding: EdgeInsets.only(bottom: 140)),
            ],
          ),
        ]),
      ),
    );
  }
}

