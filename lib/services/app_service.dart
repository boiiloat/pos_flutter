// import 'package:encrypt/encrypt.dart';
// import 'package:epos_mobile_lite/locator.dart';
// import 'package:epos_mobile_lite/models/document_number/document_number_model.dart';
// import 'package:epos_mobile_lite/models/menu/menu_product_model.dart';
// import 'package:epos_mobile_lite/models/system_setting/app_setting_model.dart';
// import 'package:epos_mobile_lite/models/user/user_model.dart';
// import 'package:epos_mobile_lite/program.dart';
// import 'package:epos_mobile_lite/services/api_service.dart';
// import 'package:flutter/services.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:intl/intl.dart';
// import 'package:platform_device_id_v3/platform_device_id.dart';
// import 'package:realm/realm.dart';

// abstract class IAppService {
//   String onDecrypted(String encrypted);
//   String onEcrypted(String plainText);

//   String onGenerateTrailLicense(String deviceId);
//   Map<dynamic, dynamic> onVerifyLicense(String license, String deviceId);

//   Future<bool> appAuthorization();
//   Future<bool> getValidUrl(String url);

//   Future<Map<String, dynamic>?> getAppSetting(Map<String, dynamic>? data_);
//   Future<List<Map<String, dynamic>?>> getPOSMenu({required String rootMenu});
//   Future<List<Map<String, dynamic>?>> getUsers();

//   Map<String, String> getUserLogon();
//   Future<String> documnetNumber({
//     required Document doc,
//     bool update = false,
//     bool reset = false,
//   });

//   Future<String> get getDeviceId;
// }

// class AppService implements IAppService {
//   final storage = GetStorage(".appsettings");
//   var api = locator<IAPIService>();
//   final key = Key.fromUtf8("NiQNF6jOiU7Kf4GaW4Y5Htb18sO3zWrf");
//   final iv = IV.fromUtf8("KiKlmSo2wWmdKXAs");

//   @override
//   Future<bool> appAuthorization() async {
//     //check server url
//     if (storage.hasData("serverUrl")) {
//       String serverUrl = storage.read("serverUrl");
//       //check raw cookie
//       if (storage.hasData("rawCookie")) {
//         String rawCookie = storage.read("rawCookie");
//         if (rawCookie.isEmpty) {
//           return _onRemoveHeaderCookie();
//         } else {
//           //set header cookie
//           int index = rawCookie.indexOf(';');
//           var cookie =
//               (index == -1) ? rawCookie : rawCookie.substring(0, index);

//           //set header cookie to storage
//           storage.write("headerCookie", cookie);
//           //set header cookie to variable

//           //function check user authorized
//           return await _onCheckAuthorized(serverUrl, cookie);
//         }
//       } else {
//         return _onRemoveHeaderCookie();
//       }
//       //end check raw cookie
//     } else {
//       //remove raw cookie and cookie
//       return _onRemoveRawCookie();
//     }
//   }

//   //method on check user authorized
//   Future<bool> _onCheckAuthorized(String serverUrl, String cookie) async {
//     var resp = await api.get(
//       serverUrl,
//       "/api/method/epos_restaurant_2023.api.utils.ping",
//       cookie: cookie,
//     );
//     return resp.isSuccess;
//   }

// //method remove header cookie
//   bool _onRemoveHeaderCookie() {
//     if (storage.hasData("headerCookie")) {
//       storage.remove("headerCookie");
//     }
//     return false;
//   }

// //method remove raw cookie
//   bool _onRemoveRawCookie() {
//     if (storage.hasData("rawCookie")) {
//       storage.remove("rawCookie");
//     }
//     return _onRemoveHeaderCookie();
//   }

//   /// on check valid url
//   @override
//   Future<bool> getValidUrl(String url) async {
//     bool validURL = Uri.parse(url).isAbsolute;
//     if (validURL) {
//       var resp = await api.get(
//           url, "/api/method/epos_restaurant_2023.api.mobile_api.on_check_url");

//       return resp.isSuccess;
//     }
//     return validURL;
//   }

//   @override
//   Map<String, String> getUserLogon() {
//     Map<String, String> userLogon = <String, String>{};
//     String rawCookie = storage.read("rawCookie");
//     try {
//       var arrRawCookie = rawCookie.split(';');
//       var sid = arrRawCookie[0].split('=');

//       var expires = arrRawCookie[1].split('=');
//       var sameSiteSystemUse = arrRawCookie[4].split(',');
//       var sameSiteFullName = arrRawCookie[6].split(',');
//       var sameSiteUserId = arrRawCookie[8].split(',');
//       var sameSiteUserImage = arrRawCookie[10].split(',');

//       var systemUser = sameSiteSystemUse[1].split('=');
//       var fullName = sameSiteFullName[1].split('=');
//       var userId = sameSiteUserId[1].split('=');
//       var userImage = sameSiteUserImage[1].split('=');

//       userLogon.addAll({sid[0].replaceAll(" ", ""): sid[1]});
//       userLogon.addAll({expires[0].replaceAll(" ", ""): expires[1]});
//       userLogon.addAll({systemUser[0].replaceAll(" ", ""): systemUser[1]});
//       userLogon.addAll({fullName[0].replaceAll(" ", ""): fullName[1]});
//       userLogon.addAll({userId[0].replaceAll(" ", ""): userId[1]});
//       userLogon.addAll({
//         userImage[0].replaceAll(" ", ""):
//             "${storage.read("serverUrl")}${userImage[1]}"
//       });

//       return userLogon;
//     } on Exception catch (_) {
//       return userLogon;
//     }
//   }

//   /// AES decrypt method
//   @override
//   String onDecrypted(encrypted) {
//     try {
//       if (encrypted.trim().isEmpty) {
//         return "";
//       }
//       final encrypter = Encrypter(
//         AES(key, mode: AESMode.cbc),
//       );
//       return encrypter.decrypt64(encrypted, iv: iv);
//     } on Exception catch (_) {
//       return "";
//     }
//   }

//   /// AES Encrypt method
//   @override
//   String onEcrypted(plainText) {
//     try {
//       if (plainText.trim().isEmpty) {
//         return "";
//       }
//       final encrypter = Encrypter(
//         AES(key, mode: AESMode.cbc),
//       );
//       final encrypted = encrypter.encrypt(plainText, iv: iv);

//       return encrypted.base64;
//     } on Exception catch (_) {
//       return "";
//     }
//   }

//   /// get device id method
//   @override
//   Future<String> get getDeviceId async {
//     String? deviceId;
//     try {
//       deviceId = await PlatformDeviceId.getDeviceId.then((value) => value);
//       deviceId = (deviceId ?? "").trim();
//     } on PlatformException {
//       deviceId = '';
//     }
//     return deviceId;
//   }

//   @override
//   Map<String, dynamic> onVerifyLicense(dynamic license, String deviceId) {
//     Map<String, dynamic> dataResponse = <String, dynamic>{
//       "status": false,
//       "message": "Invalid license",
//       "expiry_date": DateTime.now().toLocal(),
//       "is_audit_trail": true,
//       "unlimited": false,
//       "expired": false,
//       "remaining_day": 0
//     };

//     ///
//     try {
//       var dataLicense = onDecrypted(onDecrypted(license));
//       if (dataLicense.isNotEmpty) {
//         var arr = dataLicense.split('|');
//         if (arr[0] != deviceId) {
//           return dataResponse;
//         }
//         dataResponse["status"] = true;

//         if (arr.length == 1) {
//           dataResponse["message"] = "Unlimited";
//           dataResponse["expiry_date"] = "None Date";
//           dataResponse["is_audit_trail"] = false;
//           dataResponse["unlimited"] = true;
//           dataResponse["expired"] = false;

//           //
//         } else if (arr.length >= 2) {
//           dataResponse["is_audit_trail"] =
//               bool.parse(arr[2], caseSensitive: false);

//           if (dataResponse["is_audit_trail"]) {
//             dataResponse["message"] = "Trail ${getCalcDate(arr[1])}";
//             dataResponse["expiry_date"] = getCalcDate(arr[1]);
//             dataResponse["unlimited"] = false;
//           } else {
//             dataResponse["message"] =
//                 "Expiry on ${arr[1].toString()} - ${getCalcDate(arr[1])}";
//             dataResponse["expiry_date"] = getCalcDate(arr[1]);
//             dataResponse["unlimited"] = false;
//           }

//           if (onCalcDateValue(arr[1]) <= 0) {
//             if (onCalcDateValue(arr[1]) == 0) {
//               dataResponse["message"] = "License was expired";
//             } else {
//               dataResponse["expired"] = true;
//               dataResponse["message"] =
//                   "License was expired ${onCalcDateValue(arr[1]) * -1} day(s) ago";
//             }
//           }
//           dataResponse["remaining_day"] = onCalcDateValue(arr[1]);
//         }

//         return dataResponse;
//       } else {
//         return dataResponse;
//       }
//     } on Exception catch (_) {
//       return dataResponse;
//     }
//   }

//   /// function get expired day count
//   String getCalcDate(String dateString) {
//     try {
//       return "${onCalcDateValue(dateString)} day(s)";
//     } on Exception catch (_) {
//       return "0 day(s)";
//     }
//   }

//   /// function calculate today expired day count
//   int onCalcDateValue(dateString) {
//     var now = DateTime.parse(
//         DateFormat("yyyy-MM-dd").format(DateTime.now().toLocal()));
//     var expiredDate = DateTime.parse(dateString);

//     return expiredDate.difference(now).inDays;
//   }

//   /// generate trail license in 30days
//   @override
//   String onGenerateTrailLicense(String deviceId) {
//     var now = DateTime.now().toLocal().add(const Duration(days: 30));
//     var expired = DateFormat("yyyy-MM-dd").format(now);
//     var license = "$deviceId|$expired|true";
//     return onEcrypted(onEcrypted(license));
//   }

//   /// get app setting method
//   @override
//   Future<Map<String, dynamic>?> getAppSetting(
//     Map<String, dynamic>? data_,
//   ) async {
//     final db = Realm(Program.dbConfig);
//     if (data_ != null) {
//       final setting = db.all<AppSettingModel>();
//       if (setting.isNotEmpty) {
//         await db.writeAsync(() {
//           db.deleteAll<AppSettingModel>();
//         });
//       }
//       await db.writeAsync<AppSettingModel>(() {
//         var d_ = AppSettingModelJ.fromJson(data_);
//         return db.add(d_);
//       });
//     }

//     var result = db.all<AppSettingModel>();
//     if (result.isEmpty) {
//       db.close();
//       Program.appSetting = <String, dynamic>{};
//       return null;
//     }
//     Program.appSetting = result.first.toJson();
//     db.close();

//     return Program.appSetting;
//   }

//   /// get pos menu method
//   @override
//   Future<List<Map<String, dynamic>?>> getPOSMenu({
//     required String rootMenu,
//   }) async {
//     final db = Realm(Program.dbConfig);
//     var data = db.query<MenuProductModel>(
//       "root_menu == '$rootMenu'",
//     );
//     if (data.isEmpty) {
//       db.close();
//       Program.posMenus = [];
//       return [];
//     }
//     Program.posMenus = [];
//     var result = data.map((e) => e.toJson());
//     Program.posMenus.addAll(result);
//     db.close();
//     return Program.posMenus;
//   }

//   @override
//   Future<List<Map<String, dynamic>?>> getUsers() async {
//     final db = Realm(Program.dbConfig);
//     var data = db.all<UserModel>();
//     if (data.isEmpty) {
//       db.close();
//       return [];
//     }
//     List<Map<String, dynamic>> users = [];
//     var result = data.map((e) => e.toJson());
//     users.addAll(result);
//     db.close();
//     return users;
//   }

//   @override
//   Future<String> documnetNumber({
//     required Document doc,
//     bool update = false,
//     bool reset = false,
//   }) async {
//     String result = "";
//     switch (doc) {
//       case Document.workingDay:
//         String model = 'Working Day';
//         if (update || reset) {
//           await onUpdateDocumentNumber(model: model, reset: reset);
//         } else {
//           var createDoc = DocumentNumberModel(
//             ObjectId().toString(),
//             prefix: "WD",
//             format: "-yyyy-",
//             model: model,
//             counter: 0,
//             digit: 6,
//           );
//           result = await getDocNumber(
//               model: createDoc.model ?? "", newDoc: createDoc);
//         }
//         break;
//       case Document.cashierShift:
//         String model = 'Cashier Shift';
//         if (update || reset) {
//           await onUpdateDocumentNumber(model: model, reset: reset);
//         } else {
//           var createDoc = DocumentNumberModel(
//             ObjectId().toString(),
//             prefix: "CS",
//             format: "-yyyy-",
//             model: model,
//             counter: 0,
//             digit: 6,
//           );
//           result = await getDocNumber(
//               model: createDoc.model ?? "", newDoc: createDoc);
//         }
//         break;
//       case Document.sale:
//         String model = 'Sale';
//         if (update) {
//           await onUpdateDocumentNumber(model: model, reset: reset);
//         } else {
//           var createDoc = DocumentNumberModel(
//             ObjectId().toString(),
//             prefix: "SO",
//             format: "yyyy-",
//             model: model,
//             counter: 0,
//             digit: 6,
//           );
//           result = await getDocNumber(
//               model: createDoc.model ?? "", newDoc: createDoc);
//         }
//         break;
//       case Document.billNumber:
//         String model = 'Bill Number';
//         if (update) {
//           await onUpdateDocumentNumber(model: model, reset: reset);
//         } else {
//           var createDoc = DocumentNumberModel(
//             ObjectId().toString(),
//             prefix: "INV",
//             format: "-",
//             model: model,
//             counter: 0,
//             digit: 6,
//           );
//           result = await getDocNumber(
//               model: createDoc.model ?? "", newDoc: createDoc);
//         }
//         break;
//       case Document.waitingNumber:
//         String model = 'Waiting Number';
//         if (update) {
//           await onUpdateDocumentNumber(model: model, reset: reset);
//         } else {
//           var createDoc = DocumentNumberModel(
//             ObjectId().toString(),
//             prefix: "WT",
//             format: "-",
//             model: model,
//             counter: 0,
//             digit: 4,
//           );
//           result = await getDocNumber(
//               model: createDoc.model ?? "", newDoc: createDoc);
//         }
//         break;
//       default:
//         result = "NONE";
//         break;
//     }
//     return result;
//   }

//   Future<String> getDocNumber({
//     required DocumentNumberModel newDoc,
//     required String model,
//   }) async {
//     final db = Realm(Program.dbConfig);
//     var docs = db.query<DocumentNumberModel>("model == '$model'");
//     DocumentNumberModel doc = newDoc;
//     String result = "";
//     if (docs.isEmpty) {
//       await db.writeAsync(() {
//         return db.add<DocumentNumberModel>(newDoc);
//       });
//       doc = newDoc;
//     } else {
//       doc = docs[0];
//     }
//     String format = doc.prefix ?? "";
//     if ((doc.format ?? "").isNotEmpty) {
//       try {
//         format = "$format${DateFormat(doc.format).format(DateTime.now())}";
//       } on Exception catch (_) {}
//     }
//     String lengthDigit =
//         List<String>.generate(doc.digit ?? 1, (i) => "0").join('');
//     result =
//         "$format${NumberFormat(lengthDigit).format((doc.counter ?? 0) + 1)}";
//     db.close();
//     return result;
//   }

//   Future<void> onUpdateDocumentNumber(
//       {required String model, required bool reset}) async {
//     final db = Realm(Program.dbConfig);
//     var docs = db.query<DocumentNumberModel>("model == '$model'");
//     if (docs.isNotEmpty) {
//       var docUpdate = DocumentNumberModelJ.toRealmObject(docs[0]);
//       docUpdate.counter = reset ? 0 : ((docUpdate.counter ?? 0) + 1);
//       db.write(() => db.add<DocumentNumberModel>(docUpdate, update: true));
//     }
//     // db.close();
//   }
// }

// enum Document {
//   workingDay,
//   cashierShift,
//   sale,
//   billNumber,
//   waitingNumber,
//   settingDocsData,
// }
