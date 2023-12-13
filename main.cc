#include "network.h"

#include <future>
#include <iostream>

int main() {
  std::promise<void> promise;
  auto req = Request("https://jsonplaceholder.typicode.com/posts/1",
                     [&promise](Response &response) {
                       if (response.status_code == 200) {
                         std::string line;
                         while (std::getline(response.body, line)) {
                           std::cout << line << std::endl;
                         }
                       } else {
                         std::cout << "Error: " << response.error << std::endl;
                       }

                       promise.set_value();
                     });

  req.send();

  promise.get_future().wait();

  return 0;
}
