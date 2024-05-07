import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'package:docx_to_text/docx_to_text.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plagia_detect/shared/components/Constants.dart';
import 'package:plagia_detect/shared/cubits/appCubit/AppStates.dart';
import 'package:plagia_detect/shared/network/remot/DioHelper.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class AppCubit extends Cubit<AppStates> {

  AppCubit() : super(InitialAppState());

  static AppCubit get(context) => BlocProvider.of(context);

  String textContent = '';

  double progressExtracting = 0.0;

  void handleProgress(double value) {
    progressExtracting = value;
    if (kDebugMode) {
      print(progressExtracting);
    }
    emit(UpdateLoadingProgressExtractFileAppState());
  }


  Future<void> uploadDocument({
    required TextEditingController controller,
    required BuildContext context
}) async {

    emit(LoadingUploadDocumentAppState());

    await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['txt', 'pdf', 'docx'],
    ).then((value) async {

      if(value != null) {

        String? extension = value.files.single.extension;
        File file = File(value.files.single.path ?? '');

        if(file.lengthSync() > 15728640) {  // 15mb

          emit(ErrorUploadDocumentAppState('file-size'));

        } else {

          Uint8List bytes =  await compute(readFileInBackground, file.path);

          if (kDebugMode) {
            print('completed 1');
          }

          if (extension == 'pdf') {

            final PdfDocument document = PdfDocument(inputBytes: bytes);

            receivePort = ReceivePort();

            receivePort?.listen((v) {
              handleProgress(v);
              if(progressExtracting == 100.0) {
                receivePort?.close();
              }
            });

            String content = await compute(extractPdfContent, [receivePort?.sendPort, document]);

            if (kDebugMode) {
              print('completed 2');
            }

            document.dispose();
            textContent = content.trim();

          } else if (extension == 'docx') {

            String content = await compute(extractDocxContent, bytes);
            textContent = content.trim();

          } else {

            receivePort = ReceivePort();

            receivePort?.listen((v) {
              handleProgress(v);
              if(progressExtracting == 100.0) {
                receivePort?.close();
              }
            });

            String content = await compute(extractTxtContent, [receivePort?.sendPort, file]);
            textContent = content.trim();
          }

          controller.text = textContent;

          emit(SuccessUploadDocumentAppState());

        }

      } else {

        emit(ErrorUploadDocumentAppState('value-null'));

      }

    }).catchError((error) {

      if (kDebugMode) {
        print('Error in upload file -->  ${error.toString()}');
      }


      progressExtracting = 0.0;
      emit(ErrorUploadDocumentAppState(error));

    });
  }


  double progress = 0.0;
  bool isRequestInProgress = false;

  void startProgressTracking() {
    dynamic startTime = DateTime.now();

    Timer.periodic(const Duration(milliseconds: 800), (timer) {
      if (isRequestInProgress) {
        double elapsedMilliseconds = DateTime.now().difference(startTime).inMilliseconds.toDouble();

        // Assume the request will take at least 1 second to avoid division by zero
        elapsedMilliseconds = elapsedMilliseconds.clamp(1000, double.infinity);

        // Calculate the progress based on the elapsed time
        progress = (elapsedMilliseconds / 1000) / 100;
        if (kDebugMode) {
          print(progress);
        }
        emit(UpdateLoadingProgressAppState());

      } else {
        timer.cancel();
      }
    });
  }


  Map<String, dynamic> data = {};
  List<dynamic> listOfSources = [];

  void getReport({
    required String document,
}) {

    isRequestInProgress = true;
    startProgressTracking();

    emit(LoadingGetReportAppState());

    DioHelper.postData(
      pathUrl: '/report',
        data: {
          'uploaded_document': document,
        },
    ).then((value) {

      data = value?.data;
      listOfSources = [];

      if (kDebugMode) {
        print(data);
      }

      if(data['status'] == 'success') {

        listOfSources = data['sources'];

        if (kDebugMode) {
          print(listOfSources.length);
        }

        for(int i = 0; i < listOfSources.length; i++) {
          if(listOfSources[i].isEmpty) {
            listOfSources.removeAt(i);
            emit(UpdateNbrSourcesAppState());
          }
        }

        if (kDebugMode) {
          print('After: ${listOfSources.length}');
        }

        isRequestInProgress = false;
        progress = 1.0;

        emit(SuccessGetReportAppState());

      } else {

        if (kDebugMode) {
          print('Error in get report --> ${data['message_error']}');
        }

        isRequestInProgress = false;
        progress = 0.0;

        emit(ErrorGetReportAppState(data['message_error']));
      }



    }).catchError((error) {

      if (kDebugMode) {
        print('Error in get report --> $error');
      }

      isRequestInProgress = false;
      progress = 0.0;

      emit(ErrorGetReportAppState(error));
    });


  }


  void clearData() {
    data.clear();
    listOfSources.clear();
    emit(ClearDataReportAppState());
  }

}


// Run in Background to avoid UI Junk (lag)
Future<Uint8List> readFileInBackground(String filePath) async {
  File file = File(filePath);
  return await file.readAsBytes();
}


Future<String> extractPdfContent(List<dynamic> args) async {
  SendPort sendPort = args[0];
  PdfDocument document = args[1];

  int totalPages = document.pages.count;
  int pagesProcessed = 0;
  String extractedText = '';

  PdfTextExtractor extractor = PdfTextExtractor(document);

  for (int i = 0; i < totalPages; i++) {
    extractedText += extractor.extractText(startPageIndex: i, layoutText: true); // Process page by page
    pagesProcessed++;

    double progress = (pagesProcessed / totalPages) * 100;
    if (kDebugMode) {
      print('Progress sent: $progress');
    }
    sendPort.send(progress);
    if(progress == 100.0) {
      break;
    }
  }

  return extractedText;
}


String extractDocxContent(Uint8List bytes) {
  return docxToText(bytes, handleNumbering: true);
}


Future<String> extractTxtContent(List<dynamic> args) async {
  SendPort sendPort = args[0];
  File file = args[1];

  int fileSize = file.lengthSync();
  int bytesRead = 0;
  String content = '';

  Stream<List<int>> stream = file.openRead();
  await for (var chunk in stream) {
    content += utf8.decode(chunk);
    bytesRead += chunk.length;

    double progress = (bytesRead / fileSize) * 100;
    sendPort.send(progress);
    if (kDebugMode) {
      print('Progress sent: $progress');
    }
    if(progress == 100.0) {
      break;
    }
  }

  return content;
}