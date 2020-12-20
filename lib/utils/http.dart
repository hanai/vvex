import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:path_provider/path_provider.dart';

class UAInterceptor extends InterceptorsWrapper {
  @override
  Future onRequest(RequestOptions options) {
    options.headers.putIfAbsent(
        HttpHeaders.userAgentHeader,
        () =>
            'Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Mobile/15E148 Safari/604.1');
    return super.onRequest(options);
  }
}

class Http {
  static final Dio _dio = new Dio();

  static final Http _instance = Http._internal();

  factory Http() {
    getApplicationDocumentsDirectory().then((appDocDir) {
      final String appDocPath = appDocDir.path;
      final cookieJar = PersistCookieJar(dir: appDocPath + "/.cookies/");
      _dio.interceptors.add(CookieManager(cookieJar));
      _dio.interceptors.add(new UAInterceptor());
    });
    return _instance;
  }

  Http._internal();

  Future<Response<T>> get<T>(String path,
      {Map<String, dynamic> queryParameters,
      Options options,
      CancelToken cancelToken,
      void Function(int, int) onReceiveProgress}) {
    return _dio.get(path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress);
  }

  Future<Response<T>> postForm<T>(String path,
      {data,
      Map<String, dynamic> queryParameters,
      Options options,
      CancelToken cancelToken,
      ProgressCallback onSendProgress,
      ProgressCallback onReceiveProgress}) {
    FormData formData = FormData.fromMap(data);
    return _dio.post(path,
        data: formData,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress);
  }

  Future<String> getHTML<T>(String path,
      {Map<String, dynamic> queryParameters,
      Options options,
      CancelToken cancelToken,
      void Function(int, int) onReceiveProgress}) async {
    if (options == null) {
      options = Options();
    }
    options.headers.putIfAbsent(
        Headers.acceptHeader, () => 'text/html,application/xhtml+xml');
    options.responseType = ResponseType.plain;

    final res = await _dio.get(path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress);

    return res.data.toString();
  }
}
