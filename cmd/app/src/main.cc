#include <cstdio>
import hello;
import math;

int main() {
  hello::print();
  int res = math::add(1, 1);
  std::printf("Hello %d\n", res);
  return 0;
}
