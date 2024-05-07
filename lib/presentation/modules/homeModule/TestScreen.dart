// import 'dart:async';
// import 'dart:isolate';
// import 'package:animate_do/animate_do.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:plagia_detect/shared/adaptive/loadingIndicator/LoadingIndicator.dart';
// import 'package:plagia_detect/shared/components/Components.dart';
// import 'package:plagia_detect/shared/components/Constants.dart';
// import 'package:plagia_detect/shared/styles/Colors.dart';
//
// class TestScreen extends StatefulWidget {
//   const TestScreen({super.key});
//
//   @override
//   State<TestScreen> createState() => _TestScreenState();
// }
//
// class _TestScreenState extends State<TestScreen> {
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         title: const Text('Test Screen'),
//       ),
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: Column(
//             // mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               // LoadingIndicator(os: getOs()),
//               // const SizedBox(
//               //   height: 20.0,
//               // ),
//               // defaultButton(
//               //     width: MediaQuery.of(context).size.width / 2,
//               //     text: 'Without Isolation',
//               //     onPress: () {
//               //       computeValue(400000000);
//               //     },
//               //     context: context),
//               // const SizedBox(
//               //   height: 20.0,
//               // ),
//               // defaultButton(
//               //     width: MediaQuery.of(context).size.width / 2,
//               //     text: 'With Isolation',
//               //     onPress: () async {
//               //       if (kDebugMode) {
//               //         print(await isolate());
//               //       }
//               //       // var value = await compute(computeValue, 400000000);
//               //       // if (kDebugMode) {
//               //       //   print(value);
//               //       // }
//               //     },
//               //     context: context),
//              ZoomIn(
//                child: CircleAvatar(
//                  radius: 36.0,
//                  backgroundColor: Theme.of(context).colorScheme.primary,
//                  child: const Icon(
//                    Icons.question_mark_rounded,
//                    size: 40.0,
//                    color: Colors.white,
//                  ),
//                ),
//              ),
//               const SizedBox(
//                 height: 30.0,
//               ),
//               Column(
//                 children: [
//                   Image.asset('assets/images/checked.png',
//                    width: 34.0,
//                    height: 34.0,
//                   ),
//                   const SizedBox(
//                     height: 12.0,
//                   ),
//                   const Text(
//                     'الملف أصلي، ولم يتم اكتشاف أي سرقة أدبية. ',
//                     textAlign: TextAlign.start,
//                     style: TextStyle(
//                       fontSize: 17.0,
//                       fontWeight: FontWeight.bold,
//                       letterSpacing: 0.6,
//                     ),
//                   ),
//                   const SizedBox(
//                     height: 4.0,
//                   ),
//                 //   Container(
//                 //     width: 66.0,
//                 //     height: 1.4,
//                 //     color: Colors.black,
//                 //   ),
//                 ],
//               ),
//               const SizedBox(
//                 height: 30.0,
//               ),
//               const Text(
//                 'لا يزال نموذج مدقق الانتحال الخاص بنا قيد التدريب.\nستتحسن دقته عندما نقوم بإدخال المزيد من البيانات إليه. شكرا لتفهمك و صبرك.',
//                 style: TextStyle(
//                   fontSize: 16.0,
//                   height: 1.6,
//                   // color: Colors.blueGrey.shade900,
//                   // fontWeight: FontWeight.bold,
//                   letterSpacing: 0.4,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
//
// int computeValue(int value) {
//   int v = 0;
//   for (int i = 0; i < value; i++) {
//     v += 1;
//   }
//   if (kDebugMode) {
//     print(v);
//   }
//   return v;
// }
//
//
// runWithIsolation(SendPort sendPort) {
//   int v = 0;
//   for(int i = 0; i < 400000000; i++) {
//     v+=1;
//   }
//   sendPort.send(v);
// }
//
// Future isolate() async {
//
//   final ReceivePort receivePort = ReceivePort();
//
//   await Isolate.spawn(runWithIsolation, receivePort.sendPort);
//
//   final completer = Completer();
//
//   receivePort.listen((m) {
//     completer.complete(m);
//     receivePort.close();
//   });
//
//   return completer.future;
//
// }
//
