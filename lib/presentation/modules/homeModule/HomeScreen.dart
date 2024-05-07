import 'package:animate_do/animate_do.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:plagia_detect/presentation/modules/homeModule/ReportScreen.dart';
import 'package:plagia_detect/shared/adaptive/loadingIndicator/LoadingIndicator.dart';
import 'package:plagia_detect/shared/components/Components.dart';
import 'package:plagia_detect/shared/components/Constants.dart';
import 'package:plagia_detect/shared/cubits/appCubit/AppCubit.dart';
import 'package:plagia_detect/shared/cubits/appCubit/AppStates.dart';
import 'package:plagia_detect/shared/cubits/checkCubit/CheckCubit.dart';
import 'package:plagia_detect/shared/cubits/checkCubit/CheckStates.dart';
import 'package:plagia_detect/shared/styles/Colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final TextEditingController inputController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final FocusNode focusNode = FocusNode();

  bool isVisible = false;
  bool isHasFocus = false;
  bool isUploading = false;

  final ScrollController scrollController = ScrollController();

  List<String> words = [];
  bool canPop = false;


  void clearResults() {
    setState(() {
      words.clear();
      inputController.clear();
      isVisible = false;
    });
  }


  void exit(timeBackPressed) {
    final difference = DateTime.now().difference(timeBackPressed);
    final isWarning = difference >= const Duration(milliseconds: 800);
    timeBackPressed = DateTime.now();

    if (isWarning) {
      showToast(
        'اضغط مرة أخرى للخروج',
        context: context,
        backgroundColor: Colors.grey.shade800,
        animation: StyledToastAnimation.scale,
        reverseAnimation: StyledToastAnimation.fade,
        position: StyledToastPosition.bottom,
        animDuration: const Duration(seconds: 1),
        duration: const Duration(seconds: 3),
        curve: Curves.elasticOut,
        reverseCurve: Curves.linear,
      );
      setState(() {
        canPop = false;
      });
    } else {
      setState(() {
        canPop = true;
      });
      SystemNavigator.pop();
    }
  }


  @override
  void initState() {
    inputController.addListener(() {setState(() {});});
    focusNode.addListener(() {
      if(focusNode.hasPrimaryFocus) {
        setState(() {isHasFocus = true;});
      } else {
        Future.delayed(const Duration(milliseconds: 200)).then((value) {
          setState(() {isHasFocus = false;});
        });
      }
    });

    super.initState();
  }


  @override
  void dispose() {
    inputController.dispose();
    scrollController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final DateTime timeBackPressed = DateTime.now();
    return Builder(
      builder: (context) {

        final ThemeData theme = Theme.of(context);

        final bool isDarkTheme = theme.brightness == Brightness.dark;

        return BlocConsumer<CheckCubit, CheckStates>(
          listener: (context, state) {},
          builder: (context, state) {

            var checkCubit = CheckCubit.get(context);

            return BlocConsumer<AppCubit, AppStates>(
              listener: (context, state) {

                var cubit = AppCubit.get(context);

                if(state is ErrorUploadDocumentAppState) {

                  if(state.error == 'value-null') {
                    toast(
                        text: 'لم تقم بتحميل الملف',
                        position: isHasFocus
                            ? StyledToastPosition.center
                            : StyledToastPosition.bottom,
                        states: ToastStates.error,
                        context: context);

                  } else if(state.error == 'file-size') {

                    toast(
                        text: 'الملف أكبر من 15 ميجا بايت',
                        position: isHasFocus
                            ? StyledToastPosition.center
                            : StyledToastPosition.bottom,
                        states: ToastStates.error,
                        context: context);

                  } else {

                    toast(
                        text: 'فشل في تحميل الملف',
                        position: isHasFocus
                            ? StyledToastPosition.center
                            : StyledToastPosition.bottom,
                        states: ToastStates.error,
                        context: context);
                  }

                  setState(() {isUploading = false;});
                }

                if(state is SuccessUploadDocumentAppState) {
                  setState(() {
                    isUploading = false;
                    words = inputController.text.split(RegExp(r'[\s|]+'));
                    cubit.progressExtracting = 0.0;
                    Future.delayed(const Duration(milliseconds: 300)).then((value) {
                      focusNode.requestFocus();
                    });
                    if(inputController.text.isNotEmpty) {
                      if(words.length <= 10000) isVisible = true;
                    } else {
                      toast(
                          text: 'الملف يحتوي على تنسيق غير صالح. الرجاء التحقق من الملف أو تغييره والمحاولة مرة أخرى',
                          position: StyledToastPosition.center,
                          states: ToastStates.error,
                          context: context);
                    }
                  });
                }

                if(state is SuccessGetReportAppState) {
                  Future.delayed(const Duration(milliseconds: 200)).then((value) {
                    toast(text: 'تم بنجاح', states: ToastStates.success, context: context);
                    Navigator.pop(context);
                    Navigator.of(context).push(createSecondRoute(screen: const ReportScreen()));
                    clearResults();
                    cubit.progress = 0.0;
                  });

                }

                if(state is ErrorGetReportAppState) {
                  toast(text: 'فشل في الحصول على التقرير، تحقق من ملفك أو اتصالك بالإنترنت وحاول مرة أخرى',
                      states: ToastStates.error, context: context);
                  clearResults();
                  Navigator.pop(context);
                }
              },
              builder: (context, state) {

                var cubit = AppCubit.get(context);

                return PopScope(
                  canPop: canPop,
                  onPopInvoked: (v) {exit(timeBackPressed);},
                  child: Scaffold(
                    appBar: AppBar(
                      title: FadeInRight(
                        duration: const Duration(seconds: 1),
                        child: const Text(
                          'السلام عليكم!',
                        ),
                      ),
                    ),
                    body: SingleChildScrollView(
                      controller: scrollController,
                      clipBehavior: Clip.antiAlias,
                      physics: const BouncingScrollPhysics(),
                      child: FadeInRight(
                        duration: const Duration(seconds: 1),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 20.0,
                              ),
                              SizedBox(
                                height: MediaQuery.of(context).size.height / 1.3,
                                child: Card(
                                  elevation: 8.0,
                                  clipBehavior: Clip.antiAlias,
                                  surfaceTintColor: isDarkTheme ?
                                  theme.colorScheme.primary : Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Form(
                                      key: formKey,
                                      autovalidateMode: AutovalidateMode.always,
                                      child: Column(
                                        children: [
                                          Expanded(
                                            child: ConditionalBuilder(
                                              condition: !isUploading,
                                              builder: (context) => TextFormField(
                                                  controller: inputController,
                                                  focusNode: focusNode,
                                                  keyboardType: TextInputType.multiline,
                                                  maxLines: null,
                                                  style: const TextStyle(
                                                    fontSize: 14.0,
                                                    fontWeight: FontWeight.bold,
                                                    letterSpacing: 0.8,
                                                    height: 1.6,
                                                  ),
                                                  decoration: InputDecoration(
                                                    hintText: 'أدخل النص ... أو قم بتحميل ملف.',
                                                    border: InputBorder.none,
                                                    errorMaxLines: null,
                                                    errorStyle: TextStyle(
                                                      color: redColor,
                                                    ),
                                                    constraints: BoxConstraints(
                                                      maxHeight: MediaQuery.of(context).size.height / 1.3,
                                                    ),
                                                  ),
                                                  onChanged: (value) {
                                                    if(value.isEmpty) {
                                                      setState(() {words.clear();});
                                                    }
                                                    if(value.trim().isNotEmpty) {
                                                      setState(() {
                                                        words = value.split(RegExp(r'[\s|]+'));
                                                      });
                                                      if((words.length >= 100) && (words.length <= 10000)) {
                                                        setState(() {isVisible = true;});
                                                      } else {
                                                        setState(() {isVisible = false;});}
                                                    }
                                                  },
                                                  validator: (value) {
                                                    if(value == null || value.isEmpty) {
                                                      return '';
                                                    }

                                                    RegExp arabicRegex = RegExp(r'[\u0600-\u06FF]+');
                                                    bool isHasMatch = arabicRegex.hasMatch(value);
                                                    if(value.trim().isNotEmpty) {
                                                      if(!isHasMatch) {
                                                        return 'يجب أن يحتوي النص على كلمات عربية';
                                                      }

                                                      if(words.length < 100){
                                                        return 'يجب ألا يقل النص عن 100 كلمة --> ${words.length - 1}/100';
                                                      }
                                                      if(words.length > 10000) {
                                                        return 'لقد تجاوزت الحد الأقصى المسموح به';
                                                      }
                                                    }
                                                    return null;
                                                  },
                                                ),
                                              fallback: (context) => Center(child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  FadeIn(
                                                      duration: const Duration(milliseconds: 100),
                                                      child: SizedBox(
                                                          width: 35.0,
                                                          height: 35.0,
                                                          child: LoadingIndicator(os: getOs())),),
                                                  if(cubit.progressExtracting > 0.0) ...[
                                                    const SizedBox(
                                                      height: 16.0,
                                                    ),
                                                    FadeInUp(
                                                        duration: const Duration(milliseconds: 250),
                                                        child: Text(
                                                          '${cubit.progressExtracting.toInt()}%',
                                                          style: const TextStyle(
                                                            fontSize: 10.0,
                                                            letterSpacing: 0.6,
                                                            fontFamily: 'Varela',
                                                            fontWeight: FontWeight.bold,
                                                          ),
                                                        )),
                                                  ],
                                                ],
                                              )),
                                            ),
                                          ),
                                          if(!isUploading) ...[
                                            const SizedBox(
                                              height: 16.0,
                                            ),
                                            Align(
                                              alignment: Alignment.centerLeft,
                                              child: FadeIn(
                                                duration: const Duration(milliseconds: 200),
                                                child: Text(
                                                  '${(words.isNotEmpty) ?
                                                  words.length - 1 :
                                                  words.length}/10000',
                                                  style: TextStyle(
                                                    fontSize: 12.0,
                                                    letterSpacing: 1.2,
                                                    fontFamily: 'Varela',
                                                    color: (words.length > 10000) ? redColor :
                                                    (isDarkTheme ? Colors.white : Colors.black),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 16.0,
                                            ),
                                          ],
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              if(inputController.text.isEmpty && !isUploading)
                                              Visibility(
                                                visible: !isVisible,
                                                child: FadeIn(
                                                  duration: const Duration(milliseconds: 200),
                                                  child: defaultButton(
                                                      width: MediaQuery.of(context).size.width / 3,
                                                      height: 40.0,
                                                      fontSize: 16.0,
                                                      text: 'تحميل ملف',
                                                      onPress: () async {
                                                        if(checkCubit.hasInternet) {
                                                          focusNode.unfocus();
                                                          Future.delayed(const Duration(seconds: 1))
                                                              .then((value) {
                                                            setState(() {isUploading = true;});
                                                          });
                                                         await cubit.uploadDocument(
                                                              controller: inputController,
                                                              context: context);
                                                        } else {
                                                          toast(text: 'لا يوجد اتصال بالإنترنت',
                                                              states: ToastStates.error,
                                                              context: context);
                                                        }
                                                      },
                                                      context: context),
                                                ),
                                              ),
                                              if(inputController.text.isNotEmpty) ...[
                                                FadeIn(
                                                  duration: const Duration(milliseconds: 200),
                                                  child: MaterialButton(
                                                    minWidth: MediaQuery.of(context).size.width / 5.5,
                                                    onPressed: () {
                                                      focusNode.unfocus();
                                                      clearResults();},
                                                    clipBehavior: Clip.antiAlias,
                                                    elevation: 3.0,
                                                    height: 40.0,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(10.0),
                                                    ),
                                                    color: isDarkTheme ?
                                                    Colors.grey.shade800.withOpacity(.8) : lightBgColor,
                                                    child: Icon(
                                                      Icons.close_rounded,
                                                      color: isDarkTheme ? Colors.white : Colors.black,
                                                    ),
                                                  ),
                                                ),
                                                if(isVisible)
                                                const SizedBox(
                                                  width: 20.0,
                                                ),
                                              ],
                                              Visibility(
                                                visible: isVisible,
                                                child: FadeIn(
                                                  duration: const Duration(milliseconds: 200),
                                                  child: defaultButton(
                                                      width: MediaQuery.of(context).size.width / 3,
                                                      height: 40.0,
                                                      fontSize: 16.0,
                                                      text: 'تحقق',
                                                      onPress: () {
                                                        focusNode.unfocus();
                                                        if(checkCubit.hasInternet) {
                                                          if(formKey.currentState!.validate()) {
                                                             cubit.getReport(
                                                               document: inputController.text,
                                                             );
                                                             showLoading(isDarkTheme, context, isRequest: true);
                                                          }
                                                        } else {
                                                          toast(text: 'لا يوجد اتصال بالإنترنت',
                                                              states: ToastStates.error,
                                                              context: context);
                                                        }
                                                      },
                                                      context: context),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
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
}
