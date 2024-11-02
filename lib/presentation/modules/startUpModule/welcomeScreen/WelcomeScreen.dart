import 'package:animate_do/animate_do.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:plagia_detect/presentation/modules/homeModule/HomeScreen.dart';
import 'package:plagia_detect/shared/components/Components.dart';
import 'package:plagia_detect/shared/cubits/checkCubit/CheckCubit.dart';
import 'package:plagia_detect/shared/cubits/checkCubit/CheckStates.dart';
import 'package:plagia_detect/shared/network/local/CacheHelper.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CheckCubit, CheckStates>(
      listener: (context, state) {},
      builder: (context, state) {

        var checkCubit = CheckCubit.get(context);

        return Scaffold(
          appBar: AppBar(),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const SizedBox(
                  height: 20.0,
                ),
                AvatarGlow(
                  startDelay: const Duration(seconds: 1),
                  duration: const Duration(milliseconds: 2500),
                  glowColor: HexColor('77a6d9'),
                  glowShape: BoxShape.circle,
                  glowRadiusFactor: 0.55,
                  animate: true,
                  curve: Curves.fastOutSlowIn,
                  glowCount: 2,
                  repeat: true,
                  child: Image.asset('assets/images/logo.png',
                    width: 165.0,
                    height: 165.0,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(
                  height: 12.0,
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FadeInRight(
                        duration: const Duration(milliseconds: 750),
                        child: Text.rich(
                          TextSpan(
                            text: 'مرحبا بك في: ',
                            children: [
                              TextSpan(
                                text: 'Fahs',
                                style: TextStyle(
                                  fontSize: 26.0,
                                  letterSpacing: 1.0,
                                  color: HexColor('197ffc'),
                                  fontFamily: 'varela',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: ' (فحص)',
                                style: TextStyle(
                                  fontSize: 20.0,
                                  letterSpacing: 1.0,
                                  color: HexColor('197ffc'),
                                  fontFamily: 'IBMPlexSansArabic',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                            style: const TextStyle(
                              fontSize: 24.0,
                              letterSpacing: 0.8,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),
                      FadeInRight(
                        duration: const Duration(seconds: 1),
                        child: const Text(
                          'يساعدك على تجنب السرقة العلمية و تقديم عملك بكل ثقة.',
                          style: TextStyle(
                              fontSize: 20.0,
                              letterSpacing: 0.6,
                              height: 1.6,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                FadeIn(
                    duration: const Duration(milliseconds: 600),
                    child: defaultButton(
                        width: MediaQuery.of(context).size.width / 2.4,
                        text: 'ابدأ',
                        onPress: () async {
                          if(checkCubit.hasInternet) {
                            await getStarted(context);
                          } else {
                            toast(text: 'لا يوجد اتصال بالإنترنت', states: ToastStates.error, context: context);
                          }
                        },
                        context: context)),
              ],
            ),
          ),
        );
      },
    );
  }
}


 Future<void> getStarted(context) async {
   await CacheHelper.saveCachedData(key: 'isStarted', value: true).then((value) {
     if(value == true) {
       navigateAndNotReturn(context: context, screen: const HomeScreen());
     }
   });
 }