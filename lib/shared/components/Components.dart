import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:plagia_detect/shared/adaptive/loadingIndicator/LoadingIndicator.dart';
import 'package:plagia_detect/shared/components/Constants.dart';
import 'package:plagia_detect/shared/cubits/appCubit/AppCubit.dart';
import 'package:plagia_detect/shared/cubits/appCubit/AppStates.dart';
import 'package:plagia_detect/shared/styles/Colors.dart';

navigateAndNotReturn({required BuildContext context, required Widget screen}) =>
    Navigator.pushAndRemoveUntil(
        context,
        PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => screen,
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            }),
            (route) => false,
    );


Route createRoute({required screen}) {
  return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => screen,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.easeIn;

        var tween =
        Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      });
}



Route createSecondRoute({required screen}) {
  return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => screen,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(-1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeIn;

        var tween =
        Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      });
}


Widget defaultButton({
  double width = double.infinity,
  double height = 48.0,
  double fontSize = 18.0,
  required String text,
  required Function onPress,
  required BuildContext context,
}) => SizedBox(
  width: width,
  child: MaterialButton(
    clipBehavior: Clip.antiAlias,
    height: height,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),
    color: Theme.of(context).colorScheme.primary,
    onPressed: () {
      onPress();
    },
    child: Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        color: Colors.white,
        letterSpacing: 0.8,
        fontWeight: FontWeight.bold,
      ),
    ),
  ),
);


Widget defaultSecondButton({
  required Function onPress,
  required String text,
  required IconData icon
}) => OutlinedButton(
  onPressed: onPress(),
  child: Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Icon(icon),
      const SizedBox(
        width: 8.0,
      ),
      Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          letterSpacing: 0.8,
        ),
      ),
    ],
  ),
);


Widget defaultTextButton({
  required String text,
  required Function onPress,
}) => TextButton(
  onPressed: () {
    onPress();
  },
  child: Text(
    text,
    style: const TextStyle(
      fontSize: 16.5,
      letterSpacing: 0.8,
      fontWeight: FontWeight.bold,
    ),
  ),
);


// defaultAppBar({
//   required Function onPress,
//   String? title,
//   List<Widget>? actions,
// }) => AppBar(
//   clipBehavior: Clip.antiAlias,
//   scrolledUnderElevation: 0.0,
//   leading: IconButton(
//     onPressed: () {onPress();},
//     icon: const Icon(
//       Icons.arrow_back_ios_new_rounded,
//     ),
//     tooltip: 'Back',
//   ),
//   titleSpacing: 5.0,
//   title: Text(
//     title ?? '',
//     maxLines: 1,
//     style: const TextStyle(
//       overflow: TextOverflow.ellipsis,
//       fontSize: 19.0,
//       letterSpacing: 0.8,
//       fontWeight: FontWeight.bold,
//     ),
//   ),
//   actions: actions,
// );


enum ToastStates {success, error}

dynamic toast({
  required String text,
  StyledToastPosition position = StyledToastPosition.bottom,
  required ToastStates states,
  required BuildContext context,
}) => showToast(
  text,
  context: context,
  backgroundColor: chooseColor(states),
  animation: StyledToastAnimation.scale,
  reverseAnimation: StyledToastAnimation.fade,
  position: position,
  animDuration: const Duration(seconds: 1),
  duration: const Duration(seconds: 3),
  curve: Curves.elasticOut,
  reverseCurve: Curves.linear,
);


Color chooseColor(ToastStates s) {
  return switch(s) {
    ToastStates.success => greenColor,
    ToastStates.error => Colors.red,
  };
}


Widget showScore({
  required bool isDarkTheme,
  required theme,
  required double score,
  required String text,
  required Color color,
}) => ZoomIn(
  duration: const Duration(milliseconds: 800),
  child: Stack(
    alignment: Alignment.center,
    children: [
      CircularProgressIndicator(
        strokeCap: StrokeCap.round,
        strokeAlign: 14.0,
        color: color,
        backgroundColor: Colors.grey.shade300,
        value: score,
      ),
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${(score * 100).toInt()}%',
            style: TextStyle(
              fontSize: 19.0,
              color: isDarkTheme ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.8,
              fontFamily: 'Varela',
            ),
          ).animate().then(delay: const Duration(milliseconds: 350),
              duration: const Duration(milliseconds: 600))
              .fadeIn().shake(curve: Curves.easeInOut),
          Text(
            text,
            style: TextStyle(
              fontSize: 17.0,
              color: isDarkTheme ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.8,
            ),
          ).animate().then(delay: const Duration(milliseconds: 350),
              duration: const Duration(milliseconds: 600))
              .fadeIn().shake(curve: Curves.easeInOut),
        ],
      ),
    ],
  ),
);


configColors({
  required bool isDarkTheme,
  required ThemeData theme,
}) => SystemUiOverlayStyle(
  statusBarColor: isDarkTheme ? theme.scaffoldBackgroundColor : lightBgColor,
  statusBarIconBrightness: isDarkTheme ? Brightness.light : Brightness.dark,
  systemNavigationBarColor: isDarkTheme ? theme.scaffoldBackgroundColor : lightBgColor,
  systemNavigationBarIconBrightness: isDarkTheme ? Brightness.light : Brightness.dark,
);



Widget defaultDropDownButton({
  required AppCubit cubit,
  required isDarkTheme,
  required void Function(int?) onChange,
}) => DropdownButton<int>(
    value: cubit.firstValue,
    items: cubit.items.map<DropdownMenuItem<int>>((v) {
      return DropdownMenuItem<int>(
          value: v,
          child: Center(child: Text('$v')));
    }).toList(),
    elevation: 4,
    isDense: true,
    underline: Divider(
      thickness: 1.0,
      color: redColor,
      height: 0.0,
    ),
    dropdownColor: isDarkTheme ?
    darkIndicator : Colors.blue.shade50,
    borderRadius: BorderRadius.circular(8.0),
    icon: const Icon(
      Icons.keyboard_arrow_down_rounded,
    ),
    iconSize: 20.0,
    iconEnabledColor: redColor,
    style: TextStyle(
      fontSize: 14.0,
      fontWeight: FontWeight.bold,
      color: redColor,
      fontFamily: 'Varela',
    ),
    onChanged: (value) => onChange(value));





// Widget other() => Column(
//   children: [
//     const SizedBox(
//       height: 14.0,
//     ),
//     CircleAvatar(
//       radius: 36.0,
//       backgroundColor: Theme.of(context).colorScheme.primary,
//       child: const Icon(
//         Icons.question_mark_rounded,
//         size: 40.0,
//         color: Colors.white,
//       ),
//     ).animate().fadeIn().then(delay: const Duration(milliseconds: 350),
//         duration: const Duration(milliseconds: 600)).slide(),
//     const SizedBox(
//       height: 30.0,
//     ),
//     Column(
//       children: [
//         const Text(
//           'ملف غير معروف',
//           textAlign: TextAlign.start,
//           style: TextStyle(
//             fontSize: 19.0,
//             fontWeight: FontWeight.bold,
//             letterSpacing: 0.6,
//           ),
//         ),
//         const SizedBox(
//           height: 4.0,
//         ),
//         Container(
//           width: 66.0,
//           height: 1.4,
//           color: isDarkTheme ? Colors.white
//               : Colors.black,
//         ),
//       ],
//     ),
//     const SizedBox(
//       height: 30.0,
//     ),
//     Text.rich(
//       TextSpan(
//         children: [
//           const TextSpan(
//             text: 'لا يزال نموذج ',
//           ),
//           TextSpan(
//             text: 'فحص (مدقق الانتحال) ',
//             style: TextStyle(
//               color: theme.colorScheme.primary,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           const TextSpan(
//             text: 'الخاص بنا قيد التدريب ستتحسن دقته عندما نقوم بإدخال المزيد من البيانات إليه.\n',
//           ),
//           const TextSpan(
//               text: 'شكرا لتفهمك و صبرك.',
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//               )
//           ),
//         ],
//         style: const TextStyle(
//           fontSize: 16.0,
//           height: 1.6,
//           letterSpacing: 0.4,
//         ),
//       ),
//     ),
//   ],
// );




//  ------------------------------------------------------  //

dynamic showLoading(isDarkTheme, context, {bool isRequest = false}) => showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {

      return BlocBuilder<AppCubit, AppStates>(
        builder: (context, state) {
          var cubit = AppCubit.get(context);

          return FadeIn(
            duration: const Duration(milliseconds: 200),
            child: PopScope(
              canPop: false,
              child: Center(
                child: Container(
                    padding: const EdgeInsets.all(26.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18.0),
                      color: isDarkTheme ? darkIndicator : lightBgColor,
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: !isRequest ? LoadingIndicator(os: getOs())
                        : Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        LoadingIndicator(os: getOs(), value: (cubit.progress <= 1.0) ? cubit.progress : null,
                          bgColor: (cubit.progress <= 1.0) ? Colors.grey.shade300 : null,),
                        if(cubit.isRequestInProgress && (cubit.progress <= 1.0)) ...[
                          FadeIn(
                            child: const SizedBox(
                              height: 16.0,
                            ),
                          ),
                          FadeInUp(
                            duration: const Duration(milliseconds: 400),
                            child: Text(
                              'ستستغرق هذه العملية بعض الوقت،\nيرجى الانتظار ...',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 12.0,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.4,
                                height: 1.4,
                                decoration: TextDecoration.none,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                        ],
                        if(cubit.isRequestInProgress && (cubit.progress > 1.0)) ...[
                          FadeIn(
                            child: const SizedBox(
                              height: 16.0,
                            ),
                          ),
                          FadeInUp(
                            duration: const Duration(milliseconds: 400),
                            child: Text(
                              'جارٍ الانتهاء ...',
                              style: TextStyle(
                                fontSize: 12.0,
                                letterSpacing: 0.4,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.none,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                        ],],)),
              ),
            ),
          );
        },
      );
    });

dynamic showAlertExit(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) {
      HapticFeedback.vibrate();
      return FadeIn(
        duration: const Duration(milliseconds: 300),
        child: AlertDialog(
          title: const Text(
            'هل تريد الخروج؟',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18.0,
              letterSpacing: 0.6,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'لا',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                SystemNavigator.pop();
              },
              child: Text(
                'خروج',
                style: TextStyle(
                  color: redColor,
                  fontSize: 16.0,
                  letterSpacing: 0.4,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}

dynamic showAlertCheckConnection(BuildContext context , {bool isSplashScreen = false}) {
  return showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      return FadeIn(
        duration: const Duration(milliseconds: 300),
        child: PopScope(
          canPop: false,
          child: AlertDialog(
            title: const Text(
              'لا يوجد اتصال بالإنترنت',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18.0,
                letterSpacing: 0.6,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: const Text(
              'أنت غير متصل حاليا!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16.0,
                letterSpacing: 0.4,
              ),
            ),
            actions: [
              if(!isSplashScreen)
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'انتظر',
                    style: TextStyle(
                      fontSize: 16.0,
                      letterSpacing: 0.4,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              TextButton(
                onPressed: () {
                  SystemNavigator.pop();
                },
                child: Text(
                  'خروج',
                  style: TextStyle(
                    color: redColor,
                    fontSize: 16.0,
                    letterSpacing: 0.4,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
