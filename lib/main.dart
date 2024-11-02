import 'package:feedback/feedback.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:plagia_detect/generated/l10n.dart';
import 'package:plagia_detect/presentation/modules/homeModule/HomeScreen.dart';
import 'package:plagia_detect/presentation/modules/startUpModule/splashScreen/SplashScreen.dart';
import 'package:plagia_detect/presentation/modules/startUpModule/welcomeScreen/WelcomeScreen.dart';
import 'package:plagia_detect/shared/cubits/appCubit/AppCubit.dart';
import 'package:plagia_detect/shared/cubits/checkCubit/CheckCubit.dart';
import 'package:plagia_detect/shared/network/local/CacheHelper.dart';
import 'package:plagia_detect/shared/network/remot/DioHelper.dart';
import 'package:plagia_detect/shared/simpleBlocObserver/SimpleBlocObserver.dart';
import 'package:plagia_detect/shared/styles/Styles.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await CacheHelper.init();

  DioHelper.init();

  Bloc.observer = SimpleBlocObserver();

  await DioHelper.getData(pathUrl: '/').then((value) {

    if (kDebugMode) {
      print(value);
    }

  });


  var isStarted = CacheHelper.getCachedData(key: 'isStarted');

  Widget? startWidget;

  if(isStarted != null) {
    startWidget = const HomeScreen();
  } else {
    startWidget = const WelcomeScreen();
  }

  runApp(MyApp(widget: startWidget,));

}


class MyApp extends StatelessWidget {

  final Widget? widget;

  const MyApp({super.key, this.widget});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (BuildContext context) => AppCubit()),
        BlocProvider(create: (BuildContext context) => CheckCubit()..checkConnection()),
      ],
      child: BetterFeedback(
        themeMode: ThemeMode.system,
        darkTheme: darkThemeFeedback,
        theme: lightThemeFeedback,
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalFeedbackLocalizationsDelegate(),
        ],
        localeOverride: const Locale('ar'),
        child: OverlaySupport.global(
          child: MaterialApp(
            locale: const Locale('ar'),
            localizationsDelegates: const [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: S.delegate.supportedLocales,
            title: 'Flutter App',
            debugShowCheckedModeBanner: false,
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: ThemeMode.system,
            home: SplashScreen(startWidget: widget!),
          ),
        ),
      ),
    );
  }
}
