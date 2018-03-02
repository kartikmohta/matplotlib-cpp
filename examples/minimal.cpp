#include "matplotlibcpp/matplotlibcpp.h"

namespace plt = matplotlibcpp;

int main() {
    plt::init(); // Required for Python 3 (doesn't hurt for Python 2)
    plt::plot({1,3,2,4});
    plt::show();
}
