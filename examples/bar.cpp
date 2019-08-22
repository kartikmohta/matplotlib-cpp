#define _USE_MATH_DEFINES

#include "matplotlibcpp/matplotlibcpp.h"
namespace plt = matplotlibcpp;

int main(int argc, char **argv) {
    std::vector<int> test_data;
    for (int i = 0; i < 20; i++) {
        test_data.push_back(i);
    }

    plt::init(); // Required for Python 3 (doesn't hurt for Python 2)

    plt::bar(test_data);
    plt::show();

    return (0);
}
