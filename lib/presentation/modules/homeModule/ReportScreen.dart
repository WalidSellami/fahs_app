import 'dart:async';
import 'package:animate_do/animate_do.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plagia_detect/shared/adaptive/loadingIndicator/LoadingIndicator.dart';
import 'package:plagia_detect/shared/components/Components.dart';
import 'package:plagia_detect/shared/components/Constants.dart';
import 'package:plagia_detect/shared/cubits/appCubit/AppCubit.dart';
import 'package:plagia_detect/shared/cubits/appCubit/AppStates.dart';
import 'package:plagia_detect/shared/cubits/checkCubit/CheckCubit.dart';
import 'package:plagia_detect/shared/cubits/checkCubit/CheckStates.dart';
import 'package:plagia_detect/shared/styles/Colors.dart';
import 'package:url_launcher/url_launcher.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {

  // Future<File> generatePdfInBackground(data, listOfSources) async {
  //   final Completer<File> completer = Completer();
  //
  //   await Pdf().generateDocument(data, listOfSources).then((value) {
  //       completer.complete(value);
  //     }).catchError((error) {
  //       completer.completeError(error);
  //     });
  //
  //   return completer.future;
  // }

  @override
  Widget build(BuildContext context) {
    return Builder(
        builder: (context) {

          final ThemeData theme = Theme.of(context);

          final bool isDarkTheme = theme.brightness == Brightness.dark;

          return BlocConsumer<CheckCubit, CheckStates>(
            listener: (context, state) {},
            builder: (context, state) {

              // var checkCubit = CheckCubit.get(context);

              return BlocConsumer<AppCubit, AppStates>(
                listener: (context, state) {},
                builder: (context , state) {

                  var cubit = AppCubit.get(context);

                  var reportData = cubit.data;

                  return PopScope(
                    onPopInvoked: (v) async {
                      await Future.delayed(const Duration(milliseconds: 300)).then((value) {
                        cubit.clearData();
                      });
                    },
                    child: Scaffold(
                      appBar: AppBar(
                        automaticallyImplyLeading: false,
                        leading: const Icon(
                          Icons.circle,
                          size: 12.0,
                        ),
                        // leading: (reportData['document_type'] == 'Plagiarized Document') ?
                        // IconButton(
                        //   onPressed: () async {
                        //     if(checkCubit.hasInternet) {
                        //       showLoading(isDarkTheme, context);
                        //       await generatePdfInBackground(reportData, cubit.listOfSources).then((value) async {
                        //         await Future.delayed(const Duration(milliseconds: 200)).then((v) async {
                        //           Navigator.pop(context);
                        //           await Pdf.openDocument(file: value);
                        //         }).catchError((error) {
                        //           toast(text: error.toString(), states: ToastStates.error, context: context);
                        //           Navigator.pop(context);
                        //         });
                        //       });
                        //     } else {
                        //       toast(text: 'لا يوجد اتصال بالإنترنت',
                        //           states: ToastStates.error,
                        //           context: context);
                        //     }
                        //
                        //   },
                        //   icon: Icon(
                        //     Icons.picture_as_pdf_rounded,
                        //     color: theme.colorScheme.primary,
                        //     size: 30.0,
                        //   ),
                        //   enableFeedback: true,
                        //   tooltip: 'PDF',
                        // ) :
                        // const SizedBox.shrink(),
                        title: const Text(
                          'تقرير التحقق من الانتحال',
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                        centerTitle: true,
                        clipBehavior: Clip.antiAlias,
                        actions: [
                          IconButton(
                            onPressed: () async {
                              Navigator.pop(context);
                              await Future.delayed(const Duration(milliseconds: 300)).then((value) {
                                cubit.clearData();
                              });},
                            icon: const Icon(
                              Icons.arrow_forward_ios_rounded,
                            ),
                            enableFeedback: true,
                            tooltip: 'رجوع',
                          ),
                          const SizedBox(
                            width: 6.0,
                          ),
                        ],
                      ),
                      body: SlideInRight(
                        duration: const Duration(milliseconds: 800),
                        child: SingleChildScrollView(
                          clipBehavior: Clip.antiAlias,
                          physics: const BouncingScrollPhysics(),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: ConditionalBuilder(
                              condition: (reportData['document_type'] != 'Unknown Document'),
                              builder: (context) => Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: 14.0,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      showScore(isDarkTheme: isDarkTheme, theme: theme,
                                          score: reportData['original_score'], text: 'أصلي', color: greenColor),
                                      showScore(isDarkTheme: isDarkTheme, theme: theme,
                                          score: reportData['plagiarism_score'], text: 'مسروق', color: redColor),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 50.0,
                                  ),
                                  ConditionalBuilder(
                                    condition: (reportData['document_type'] == 'Plagiarized Document') &&
                                        (reportData['plagiarized_texts'].isNotEmpty),
                                    builder: (context) => Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text(
                                              'عرض النصوص مع المصادر المنتحلة:',
                                              style: TextStyle(
                                                fontSize: 17.0,
                                                fontWeight: FontWeight.bold,
                                                letterSpacing: 0.8,
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  '%',
                                                  style: TextStyle(
                                                    fontSize: 12.0,
                                                    color: redColor,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 2.0,
                                                ),
                                                DropdownButton<int>(
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
                                                    onChanged: (value) => cubit.changeDropValue(value)),
                                              ],
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 20.0,
                                        ),
                                        (!cubit.isChanging) ?
                                        ListView.separated(
                                            shrinkWrap: true,
                                            physics: const NeverScrollableScrollPhysics(),
                                            itemBuilder: (context, index) => buildItemResults(
                                                cubit.plagiarizedTexts,
                                                cubit.listOfSources[index],
                                                index, isDarkTheme),
                                            separatorBuilder: (context, index) => Padding(
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0,
                                                vertical: 14.0,
                                              ),
                                              child: Divider(
                                                thickness: 2.0,
                                                color: isDarkTheme ? Colors.white : Colors.black,
                                              ),
                                            ),
                                            itemCount: cubit.listOfSources.length) :
                                        Center(child: Padding(
                                          padding: const EdgeInsets.all(20.0),
                                          child: LoadingIndicator(os: getOs()),
                                        )),
                                      ],
                                    ),
                                    fallback: (context) => Center(
                                      child: Column(
                                        children: [
                                          const SizedBox(
                                            height: 12.0,
                                          ),
                                          Image.asset('assets/images/checked.png',
                                            width: 34.0,
                                            height: 34.0,
                                          ).animate().fadeIn().then(delay: const Duration(milliseconds: 350),
                                              duration: const Duration(milliseconds: 600)).slide(),
                                          const SizedBox(
                                            height: 14.0,
                                          ),
                                          const Text(
                                            'الملف أصلي، ولم يتم اكتشاف أي سرقة أدبية.',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 17.0,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 0.8,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              fallback: (context) => Column(
                                children: [
                                  const SizedBox(
                                    height: 14.0,
                                  ),
                                  CircleAvatar(
                                    radius: 36.0,
                                    backgroundColor: Theme.of(context).colorScheme.primary,
                                    child: const Icon(
                                      Icons.question_mark_rounded,
                                      size: 40.0,
                                      color: Colors.white,
                                    ),
                                  ).animate().fadeIn().then(delay: const Duration(milliseconds: 350),
                                      duration: const Duration(milliseconds: 600)).slide(),
                                  const SizedBox(
                                    height: 30.0,
                                  ),
                                  Column(
                                    children: [
                                      const Text(
                                        'ملف غير معروف',
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          fontSize: 19.0,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 0.6,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 4.0,
                                      ),
                                      Container(
                                        width: 66.0,
                                        height: 1.4,
                                        color: isDarkTheme ? Colors.white
                                            : Colors.black,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 30.0,
                                  ),
                                  Text.rich(
                                    TextSpan(
                                      children: [
                                        const TextSpan(
                                          text: 'لا يزال نموذج ',
                                        ),
                                        TextSpan(
                                          text: 'فحص (مدقق الانتحال) ',
                                          style: TextStyle(
                                            color: theme.colorScheme.primary,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const TextSpan(
                                          text: 'الخاص بنا قيد التدريب ستتحسن دقته عندما نقوم بإدخال المزيد من البيانات إليه.\n',
                                        ),
                                        const TextSpan(
                                            text: 'شكرا لتفهمك و صبرك.',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            )
                                        ),
                                      ],
                                      style: const TextStyle(
                                        fontSize: 16.0,
                                        height: 1.6,
                                        letterSpacing: 0.4,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          );
        }
    );
  }

  Widget buildItemResults(List<String> texts, List<dynamic> sources, index, isDarkTheme) => Padding(
    padding: const EdgeInsets.symmetric(
      horizontal: 22.0,
      vertical: 12.0,
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 8.0,
            vertical: 6.0,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            color: isDarkTheme ? Colors.grey.shade800.withOpacity(.8) :
            Colors.blueGrey.shade100.withOpacity(.5),
          ),
          child: SelectableText(
            '${texts[index]}',
            style: const TextStyle(
              fontSize: 15.0,
              letterSpacing: 0.4,
              height: 1.6,
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Center(
            child: Icon(
              Icons.arrow_drop_down_sharp,
            ),
          ),
        ),
        const SizedBox(
          height: 8.0,
        ),
        Wrap(
          clipBehavior: Clip.antiAlias,
          runSpacing: 15.0,
          children: sources.map((url) => buildItemSource(url)).toList(),
        ),
      ],
    ),
  );


  Widget buildItemSource(String baseUrl) => InkWell(
    onTap: () async {
      if(CheckCubit.get(context).hasInternet) {
        await HapticFeedback.vibrate();
        // if(!baseUrl.contains('https') || !baseUrl.contains('http')) {
        //   baseUrl = 'https://$baseUrl';
        // }
        await launch(baseUrl).then((value) {
          toast(
              text: '... جارٍ',
              states: ToastStates.success,
              context: context);
        }).catchError((error) {
          toast(
              text: error.toString(),
              states: ToastStates.error,
              context: context);
        });

      } else {
        toast(text: 'لا يوجد اتصال بالإنترنت',
            states: ToastStates.error,
            context: context);
      }
    },
    borderRadius: BorderRadius.circular(4.0),
    child: Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 8.0,
        vertical: 0.0,
      ),
      child: Center(
        child: Text(
          baseUrl,
          maxLines: 3,
          textAlign: TextAlign.center,
          textDirection: TextDirection.ltr,
          style: TextStyle(
            fontSize: 13.6,
            color: Theme.of(context).colorScheme.primary,
            height: 1.6,
            overflow: TextOverflow.ellipsis,
            letterSpacing: 0.8,
            fontWeight: FontWeight.bold,
            fontFamily: 'Varela',
          ),
        ),
      ),
    ),
  );


  Future<void> launch(String url) async {
    final Uri baseUrl = Uri.parse(url);
    if (await canLaunchUrl(baseUrl)) {
      await launchUrl(baseUrl, mode: LaunchMode.externalApplication);
    }
  }



}
