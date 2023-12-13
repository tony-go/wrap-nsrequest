#ifndef NETWORK_H
#define NETWORK_H

#include <functional>
#include <map>
#include <memory>
#include <sstream>
#include <string>

struct Internal;

struct Response {
  int status_code;
  std::istringstream body;
  std::map<std::string, std::string> headers;
  std::string error;
};

using RequestCallback = std::function<void(Response &response)>;

class Request {
public:
  Request(const std::string &url, RequestCallback callback);
  auto operator<<(const std::string &data) -> Request &;
  auto send() -> void;

private:
  RequestCallback callback_;
  Internal *internal_;
};

#endif // NETWORK_H
