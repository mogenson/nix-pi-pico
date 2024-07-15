cmake_minimum_required(VERSION ${CMAKE_VERSION})

# Pull in SDK (must be before project)
include($ENV{PICO_SDK_PATH}/external/pico_sdk_import.cmake)
include($ENV{PICO_EXTRAS_PATH}/external/pico_extras_import.cmake)

project(MyAsyncProject C CXX ASM)
set(CMAKE_C_STANDARD 11)
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
set(CMAKE_CXX_IMPLICIT_INCLUDE_DIRECTORIES $ENV{ARM_NONE_EABI_INCLUDE_PATH})
set(CMAKE_C_IMPLICIT_INCLUDE_DIRECTORIES $ENV{ARM_NONE_EABI_INCLUDE_PATH})

# Initialize the SDK
pico_sdk_init()

# Add Pico Async
set(ASYNC_EXTERNAL_SOURCE_DIR $ENV{PICO_ASYNC_PATH}/Async CACHE PATH "Async")
add_subdirectory(${ASYNC_EXTERNAL_SOURCE_DIR} Async)

add_executable(my_async_app main.cpp)
target_link_libraries(my_async_app
        Async ssd1306
        pico_stdlib pico_multicore)
pico_add_extra_outputs(my_async_app)

# enable usb output, disable uart output
pico_enable_stdio_usb(my_async_app 1)
pico_enable_stdio_uart(my_async_app 0)
