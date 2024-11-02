import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plagia_detect/shared/adaptive/loadingIndicator/LoadingIndicator.dart';
import 'package:plagia_detect/shared/components/Components.dart';
import 'package:plagia_detect/shared/components/Constants.dart';
import 'package:plagia_detect/shared/cubits/checkCubit/CheckCubit.dart';
import 'package:plagia_detect/shared/cubits/checkCubit/CheckStates.dart';

class SplashScreen extends StatefulWidget {

  final Widget startWidget;

  const SplashScreen({super.key,required this.startWidget});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  bool isDisconnected = false;
  bool isChecking = false;
  bool isShowed = false;

  @override
  void initState() {
    super.initState();

    final startTime = DateTime.now();

    Future.delayed(const Duration(milliseconds: 1500)).then((value) {
      if(!mounted) return;

      if(CheckCubit.get(context).hasInternet == true) {

        navigateAndNotReturn(context: context, screen: widget.startWidget);
        CheckCubit.get(context).changeStatus();

        if(isChecking) {
          setState(() {isChecking = false;});
        }

      } else {

        Future.delayed(const Duration(milliseconds: 1500)).then((value) {
          if(!isDisconnected) {
            setState(() {isChecking = true;});

            Future.delayed(const Duration(seconds: 5)).then((value) {
              if(!mounted) return;

              if(isChecking) {
                final elapsedTime = DateTime.now().difference(startTime).inSeconds;

                if (elapsedTime > 5) {
                  setState(() {
                    isChecking = false;
                    isShowed = true;
                  });
                  showAlertCheckConnection(context, isSplashScreen: true);
                }
              }
            });
          }
        });
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CheckCubit, CheckStates>(
      listener: (context, state) {

        var checkCubit = CheckCubit.get(context);

        if(state is CheckConnectionState) {
          if(!checkCubit.hasInternet) {
            Future.delayed(const Duration(milliseconds: 800)).then((value) {
              if(context.mounted) {
                setState(() {isDisconnected = true;});
                if(isChecking) setState(() {isChecking = false;});
                if(!isShowed) showAlertCheckConnection(context, isSplashScreen: true);
              }
            });
          }
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(),
          body: Column(
            children: [
              Expanded(
                child: ZoomIn(
                  duration: const Duration(milliseconds: 700),
                  child: Center(
                    child: Image.asset('assets/images/logo.png',
                      height: 175.0,
                      width: 175.0,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              AnimatedSize(
                duration: Duration(milliseconds: 700),
                clipBehavior: Clip.antiAlias,
                curve: Curves.easeInOut,
                child: Column(
                  children: [
                    if(isChecking) ...[
                      FadeInUp(
                        duration: const Duration(milliseconds: 500),
                        child: const Text(
                          'جارٍ التحقق من الاتصال ...',
                          style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.6,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      FadeInUp(duration: const Duration(milliseconds: 800),
                          child: SizedBox(
                              width: 25.0,
                              height: 25.0,
                              child: LoadingIndicator(os: getOs(), strokeWidth: 3.0,))),
                      const SizedBox(
                        height: 20.0,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
