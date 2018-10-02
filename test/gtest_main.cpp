/**
 * gtest_main.cpp
 *
 * The main file for Google Unit testing
 *
 * @author  Christian H. Bohlbro
 * @date    2018.08.30
 * @version 0.1
 */

#include <gtest/gtest.h>

int main(int argc, char **argv)
{
    ::testing::InitGoogleTest(&argc, argv);
    return RUN_ALL_TESTS();
}
