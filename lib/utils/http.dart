import 'dart:io';

// ignore: import_of_legacy_library_into_null_safe
import 'package:cookie_jar/cookie_jar.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:dio/dio.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:path_provider/path_provider.dart';

class UAInterceptor extends InterceptorsWrapper {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers.putIfAbsent(
        HttpHeaders.userAgentHeader,
        () =>
            'Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Mobile/15E148 Safari/604.1');
    return super.onRequest(options, handler);
  }
}

class Http {
  static final Dio _dio = new Dio();

  static final Http _instance = Http._internal();

  static PersistCookieJar? cookieJar;

  factory Http() {
    getApplicationDocumentsDirectory().then((appDocDir) {
      final String appDocPath = appDocDir.path;
      cookieJar = PersistCookieJar(
          ignoreExpires: false,
          storage: FileStorage(appDocPath + "/.cookies/"));
      _dio.interceptors.add(CookieManager(cookieJar!));
      _dio.interceptors.add(new UAInterceptor());
    });
    return _instance;
  }

  void clearCookie() {
    if (cookieJar != null) {
      cookieJar!.deleteAll();
    }
  }

  Http._internal();

  Future<Response<T>> get<T>(String path,
      {Map<String, dynamic>? queryParameters,
      Options? options,
      CancelToken? cancelToken,
      void Function(int, int)? onReceiveProgress}) {
    return _dio.get(path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress);
  }

  Future<Response<T>> postForm<T>(String path,
      {data,
      Map<String, dynamic>? queryParameters,
      Options? options,
      CancelToken? cancelToken,
      ProgressCallback? onSendProgress,
      ProgressCallback? onReceiveProgress}) {
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
      {Map<String, dynamic>? queryParameters,
      Options? options,
      CancelToken? cancelToken,
      void Function(int, int)? onReceiveProgress}) async {
    if (options == null) {
      options = Options();
    }
    options.headers?.putIfAbsent(
        Headers.acceptHeader, () => 'text/html,application/xhtml+xml');

    options.responseType = ResponseType.plain;

    final res = await _dio.get(path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress);

    return res.data.toString();
  }

  Future<String> getHTMLPC<T>(String path,
      {Map<String, dynamic>? queryParameters,
      Options? options,
      CancelToken? cancelToken,
      void Function(int, int)? onReceiveProgress}) async {
    if (options == null) {
      options = Options();
    }
    options.headers?.putIfAbsent(
        HttpHeaders.userAgentHeader,
        () =>
            'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/87.0.4280.88 Safari/537.36');

    return getHTML<T>(path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress);
  }
}
