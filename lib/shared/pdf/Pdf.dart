import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

class Pdf {

  Future<File> generateDocument(data, List<dynamic> listOfSources) async {

    final pdf = Document();

    var customFont = Font.ttf(
        await rootBundle.load("assets/fonts/IBMPlexSansArabic-Regular.ttf"));
    var anotherCustomFont = Font.ttf(
        await rootBundle.load("assets/fonts/VarelaRound-Regular.ttf"));

    final byteData = await rootBundle.load('assets/images/down-arrow.png');
    final bytes = byteData.buffer.asUint8List();

    pdf.addPage(
      MultiPage(
          maxPages: 100,
          build: (context) => [
            Center(
              child: Text(
                'تقرير التحقق من الانتحال',
                textDirection: TextDirection.rtl,
                style: TextStyle(
                  font: customFont,
                  fontSize: 26.0,
                  letterSpacing: 0.4,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Divider(
              color: PdfColors.black,
              thickness: 1.0,
              indent: 10.0,
            ),
            SizedBox(
              height: 20.0,
            ),
            ListView.separated(
                itemBuilder: (context, index) => buildItemResults(
                    data, listOfSources[index], index, bytes, customFont, anotherCustomFont),
                separatorBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40.0,
                    vertical: 16.0,
                  ),
                  child: Divider(
                    thickness: 1.0,
                    color: PdfColors.grey,
                  ),
                ),
                itemCount: listOfSources.length),
          ]),
    );

    return saveDocument(name: 'Report_PlagCheck.pdf', pdf: pdf);
  }


  Future<File> saveDocument({required String name, required Document pdf}) async {
    // final bytes = await pdf.save();
    final bytes = await compute(saveFile, pdf);

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$name');


    await compute(writeFile, [file, bytes]);
    // await file.writeAsBytes(bytes);

    return file;
  }


  static Future openDocument({
    required File file,
  }) async {
    final String path = file.path;

    return await OpenFilex.open(path);
  }
}



// To prevent UI Junk (lag)
Future<Uint8List> saveFile(Document pdf) async {
  final bytes = await pdf.save();
  return bytes;
}

Future writeFile(List<dynamic> args) async {
   File file = args[0];
   Uint8List bytes = args[1];
   await file.writeAsBytes(bytes);
}






Widget buildItemResults(data, List<dynamic> sources, index, bytes, customFont, anotherCustomFont) => Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 24.0,
        vertical: 12.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  9.0,
                ),
                color: PdfColors.grey200,
              ),
              child: Text(
                '${data['plagiarized_texts'][index]}',
                textDirection: TextDirection.rtl,
                style: TextStyle(
                  font: customFont,
                  fontSize: 15.0,
                  letterSpacing: 0.4,
                  height: 1.6,
                ),
              ),
            ),
          Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Image(
                  MemoryImage(bytes),
                  width: 10.0,
                  height: 10.0,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          Wrap(
            runSpacing: 15.0,
            children: sources.map((url) => buildItemPdfSource(url, anotherCustomFont)).toList(),
          ),
        ],
      ),
    );


Widget buildItemPdfSource(String baseUrl, anotherCustomFont) => Text(
        baseUrl,
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
        overflow: TextOverflow.clip,
        style: TextStyle(
          fontSize: 14.0,
          color: PdfColors.blue600,
          height: 1.6,
          letterSpacing: 0.8,
          fontWeight: FontWeight.bold,
          font: anotherCustomFont,
        ),
    );
