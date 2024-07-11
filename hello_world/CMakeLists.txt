if (TARGET tinyusb_device)
    add_executable(hello_world
            hello_world.c
            )

    # pull in common dependencies
    target_link_libraries(hello_world pico_stdlib)

    # enable usb output, disable uart output
    pico_enable_stdio_usb(hello_world 1)
    pico_enable_stdio_uart(hello_world 0)

    # create map/bin/hex/uf2 file etc.
    pico_add_extra_outputs(hello_world)

elseif(PICO_ON_DEVICE)
    message(WARNING "not building hello_world because TinyUSB submodule is not initialized in the SDK")
endif()
