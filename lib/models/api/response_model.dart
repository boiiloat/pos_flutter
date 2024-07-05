//200 Successful,
//201 Created
//400 Bad Request,
//401 Unauthorized,
//404 Not Found,
//409 Conflict,
//500 Internal Server Error

//General GET Response
class GETResponse {
  int? statusCode;
  bool isSuccess = false;
  String content = "";
  String message = "";
  Map<String, String>? headers;
  GETResponse(int statusCode_, Map<String, String>? headers_) {
    statusCode = statusCode_;
    headers = headers_;
    isSuccess = GETAPIMessage(statusCode_).isSuccess;
    message = GETAPIMessage(statusCode_).message;
  }
}

class POSTResponse {
  int? statusCode;
  bool isSuccess = false;
  String content = "";
  String message = "";
  Map<String, String>? headers;
  POSTResponse(int statusCode_, Map<String, String>? headers_) {
    statusCode = statusCode_;
    headers = headers_;
    isSuccess = GETAPIMessage(statusCode_).isSuccess;
    message = GETAPIMessage(statusCode_).message;
  }
}

class GETAPIMessage {
  String message = "";
  bool isSuccess = false;
  GETAPIMessage(int code) {
    switch (code) {
      case 200:
        isSuccess = true;
        message = "Success";
        break;
      case 201:
        isSuccess = true;
        message = "Created";
        break;
      case 204:
        isSuccess = true;
        message = "No Content";
        break;
      case 400:
        isSuccess = false;
        message = "Bad Request";
        break;
      case 401:
        isSuccess = false;
        message = "Unauthorized";
        break;
      case 403:
        isSuccess = false;
        message = "Forbidden";
        break;
      case 404:
        isSuccess = false;
        message = "Not Found";
        break;
      case 409:
        isSuccess = false;
        message = "Conflict";
        break;
      case 408:
        isSuccess = false;
        message = "Connection Timeout";
        break;
      case 500:
        isSuccess = false;
        message = "Internal Server Error";
        break;

      case 600:
        isSuccess = false;
        message = "You're no internet connection";
        break;
      default:
        isSuccess = false;
        message = "Error";
        break;
    }
  }
}
