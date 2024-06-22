// import 'dart:convert';
// import 'dart:io';

// import 'package:get_storage/get_storage.dart';
// import 'package:http/http.dart' as http;
// import '../models/api/response_model.dart';

// abstract class IAPIService {
//   /// rest api method get request
//   Future<GETResponse> get(
//     String baseUrl,
//     String endPoint, {
//     Map<String, String>? header,
//     String? cookie,
//   });

//   /// rest api method post request
//   Future<POSTResponse> post(
//     String baseUrl,
//     String endPoint, {
//     Map<String, String>? header,
//     String? cookie,
//     Object? body,
//   });

//   /// rest api method get with cookie header
//   Future<GETResponse> getWithCookie(
//     String baseUrl,
//     String endPoint, {
//     Map<String, String>? header,
//   });

//   /// rest api method post with cookie header
//   Future<POSTResponse> postWithCookie(
//     String baseUrl,
//     String endPoint, {
//     Map<String, String>? header,
//     Object? body,
//   });
// }

// class APIService implements IAPIService {
//   /// timeout duration (second)
//   final int timeout = 20;
//   final storage = GetStorage(".appsettings");

//   /// rest api get method
//   @override
//   Future<GETResponse> get(String baseUrl, String endPoint,
//       {Map<String, String>? header, String? cookie}) async {
//     Map<String, String> header_;
//     if (header != null) {
//       header_ = header;
//     } else {
//       header_ = <String, String>{
//         'Accept': 'application/json',
//         'Content-Type': 'application/json',
//         'Connection': 'Keep-Alive',
//       };
//       if (cookie != null) {
//         header_.addAll({'Cookie': cookie});
//       }
//     }

//     var apiUrl = Uri.parse('$baseUrl$endPoint');
//     try {
//       var client = http.Client();
//       http.Response r = await client
//           .get(apiUrl, headers: header_)
//           .timeout(Duration(seconds: timeout), onTimeout: () {
//         return http.Response.bytes([], 408);
//       });

//       GETResponse resp = GETResponse(r.statusCode.toInt(), r.headers);
//       if (resp.isSuccess) {
//         resp.content = r.body.toString();
//       } else {
//         if (r.body != "") {
//           dynamic data = jsonDecode(r.body);
//           try {
//             if ((data['_server_messages'] ?? "") != "") {
//               var serverMsg = jsonDecode(data['_server_messages']);
//               var msg = jsonDecode(serverMsg[0]);
//               resp.message = msg["message"] ?? "";
//             }
//           } on Exception catch (err) {
//             resp.message = err.toString();
//           }
//         }
//       }
//       client.close();
//       return resp;
//     } on SocketException {
//       GETResponse resp = GETResponse(600, null);
//       return resp;
//     }
//   }

//   /// rest api method post request
//   @override
//   Future<POSTResponse> post(
//     String baseUrl,
//     String endPoint, {
//     Map<String, String>? header,
//     String? cookie,
//     Object? body,
//   }) async {
//     Map<String, String> header_;
//     if (header != null) {
//       header_ = header;
//     } else {
//       header_ = <String, String>{
//         'Accept': 'application/json',
//         'Content-Type': 'application/json',
//         'Connection': 'Keep-Alive',
//       };
//       if (cookie != null) {
//         header_.addAll({'Cookie': cookie});
//       }
//     }

//     var apiUrl = Uri.parse('$baseUrl$endPoint');
//     try {
//       if (body == null) {
//         var client = http.Client();
//         http.Response r = await client
//             .post(apiUrl, headers: header_)
//             .timeout(Duration(seconds: timeout), onTimeout: () {
//           return http.Response.bytes([], 408);
//         });
//         //Custom Response API
//         POSTResponse resp = POSTResponse(r.statusCode, r.headers);
//         if (resp.isSuccess) {
//           resp.content = r.body.toString();
//         }
//         client.close();
//         return resp;
//       } else {
//         var client = http.Client();
//         http.Response r = await http
//             .post(apiUrl, headers: header_, body: body)
//             .timeout(Duration(seconds: timeout), onTimeout: () {
//           return http.Response.bytes([], 408);
//         });

//         POSTResponse resp = POSTResponse(r.statusCode, r.headers);
//         if (resp.isSuccess) {
//           resp.content = r.body.toString();
//         } else {
//           if (r.body != "") {
//             dynamic data = jsonDecode(r.body);
//             if (data['message'] != "") {
//               resp.message = data['message'];
//             }
//           }
//         }
//         client.close();
//         return resp;
//       }
//     } on SocketException {
//       POSTResponse resp = POSTResponse(600, null);
//       return resp;
//     }
//   }

//   /// rest api method get request with cookie header
//   @override
//   Future<GETResponse> getWithCookie(String baseUrl, String endPoint,
//       {Map<String, String>? header}) async {
//     String cookie = "";

//     Map<String, String> header_;
//     if (header != null) {
//       header_ = header;
//     } else {
//       if (storage.hasData("headerCookie")) {
//         cookie = storage.read("headerCookie");
//       }
//       header_ = <String, String>{
//         'Accept': 'application/json',
//         'Content-Type': 'application/json',
//         'Connection': 'Keep-Alive',
//       };
//       if (cookie != "") {
//         header_.addAll({'Cookie': cookie});
//       }
//     }
//     var resp = await get(baseUrl, endPoint, header: header, cookie: cookie);
//     return resp;
//   }

//   /// rest api method post request with cookie header
//   @override
//   Future<POSTResponse> postWithCookie(String baseUrl, String endPoint,
//       {Map<String, String>? header, Object? body}) async {
//     String cookie = "";
//     Map<String, String> header_;
//     if (header != null) {
//       header_ = header;
//     } else {
//       if (storage.hasData("headerCookie")) {
//         cookie = storage.read("headerCookie");
//       }
//       header_ = <String, String>{
//         'Accept': 'application/json',
//         'Content-Type': 'application/json',
//         'Connection': 'Keep-Alive',
//       };
//       if (cookie != "") {
//         header_.addAll({'Cookie': cookie});
//       }
//     }
//     var resp = await post(
//       baseUrl,
//       endPoint,
//       header: header,
//       body: body,
//       cookie: cookie,
//     );
//     return resp;
//   }
// }
