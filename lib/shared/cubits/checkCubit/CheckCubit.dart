import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plagia_detect/shared/cubits/checkCubit/CheckStates.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:plagia_detect/shared/styles/Colors.dart';

class CheckCubit extends Cubit<CheckStates> {

  CheckCubit() : super(InitialCheckConnectionState());

  static CheckCubit get(context) => BlocProvider.of(context);


  bool hasInternet = false;
  bool isSplashScreen = true;


  void checkConnection() {

    InternetConnectionChecker().onStatusChange.listen((event) {

      final bool isConnected = event == InternetConnectionStatus.connected;

      hasInternet = isConnected;

      (!isSplashScreen) ? showSimpleNotification(
        (hasInternet) ? const Text(
          'أنت متصل بالإنترنت',
          style: TextStyle(
            fontSize: 17.0,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ) : const Text(
          'أنت غير متصل بالإنترنت',
          style: TextStyle(
            fontSize: 17.0,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        background: (hasInternet) ? greenColor : Colors.red,
      ) : null;

      emit(CheckConnectionState());

    });

  }


  void changeStatus() {
    isSplashScreen = false;
    emit(ChangeStatusCheckState());
  }


}