#include "network.h"

#include <memory>
#include <sstream>
#include <string>

#import <Foundation/Foundation.h>

struct Internal {
  NSMutableURLRequest *request;
  NSMutableData *data;
};

Request::Request(const std::string &url, RequestCallback callback) {
  callback_ = callback;

  NSURL *nsurl =
      [NSURL URLWithString:[NSString stringWithUTF8String:url.c_str()]];
  NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:nsurl];
  NSMutableData *data = [[NSMutableData alloc] init];
  [request setHTTPBody:data];

  Internal *internal = new Internal{
      .request = request,
      .data = data,
  };
  internal_ = internal;
}

auto Request::operator<<(const std::string &data) -> Request & {
  [internal_->data appendData:[NSData dataWithBytes:data.c_str()
                                             length:data.length()]];
  return *this;
}

auto Request::send() -> void {
  auto callback = callback_;
  NSURLSession *session = [NSURLSession sharedSession];
  NSURLSessionDataTask *task = [session
      dataTaskWithRequest:internal_->request
        completionHandler:^(NSData *data, NSURLResponse *response,
                            NSError *error) {
          if (error) {
            std::string error_string = [error.localizedDescription UTF8String];
            std::istringstream body_stream("");
            Response response_obj{
                .status_code = 500,
                .body = std::move(body_stream),
                .headers = {},
                .error = error_string,
            };
            callback(response_obj);
            return;
          }
          NSHTTPURLResponse *http_response = (NSHTTPURLResponse *)response;
          NSString *body_nsstring =
              [[NSString alloc] initWithData:data
                                    encoding:NSUTF8StringEncoding];
          std::string body_string = [body_nsstring UTF8String];
          std::istringstream body_stream(body_string);
          Response response_obj{.status_code = 200,
                                .body = std::move(body_stream),
                                .headers = {},
                                .error = ""};
          callback(response_obj);
        }];
  [task resume];
}
