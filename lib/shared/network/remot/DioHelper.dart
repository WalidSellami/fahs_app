import 'package:dio/dio.dart';

class DioHelper {

  static Dio? dio;

  static void init() {

    dio = Dio(
      BaseOptions(
        baseUrl: 'your-ip-address:8000',
        receiveDataWhenStatusError: true,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

  }




  static Future<Response?> getData({
    required String pathUrl,
}) async {
    return await dio?.get(pathUrl,);
  }


  static Future<Response?> postData({
    required String pathUrl,
    required Map<String, dynamic> data,
  }) async {
    return await dio?.post(
      pathUrl,
      data: data,
    );
  }



}