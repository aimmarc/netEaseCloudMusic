import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:cookie_jar/cookie_jar.dart';

class DioUtil {
  static DioUtil _instance;
  static DioUtil getInstance() {
    if (_instance == null) {
      _instance = DioUtil();
    }
    return _instance;
  }

  Dio dio = new Dio();

  DioUtil() {
    dio.options.baseUrl = "http://192.168.0.193:3000";
    dio.options.connectTimeout = 20000;
    dio.options.receiveTimeout = 20000;

    getTemporaryDirectory().then((tempDir) {
      CookieJar cj = new PersistCookieJar(dir: tempDir.path);
      dio.interceptors.add(CookieManager(cj));
    });
  }

  get(String url, params, Function successCallBack,
      Function errorCallBack) async {
    try {
      Response response =
          await dio.get(url, queryParameters: params).catchError(errorCallBack);
      final data = response.data;
      if (data['code'] == 200) {
        successCallBack();
      } else {
        errorCallBack(data);
      }
    } catch (e) {
      errorCallBack(e);
    }
  }

  post(String url, params) async {
    // print(successCallBack);
    return await dio.post(url, data: params);
  }
}
