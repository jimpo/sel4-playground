cmake_minimum_required(VERSION 3.7.2)

project(pigpio C)

# This only works on rpi3
if(
    NOT
    "${KernelArch}"
    STREQUAL
    "arm"
    OR
        NOT
        "${KernelARMPlatform}"
        STREQUAL
        "rpi3"
)
    message(FATAL_ERROR "pigpio application only supported on Arm rpi3")
endif()

DeclareCAmkESComponent(Controller SOURCES components/Controller/src/main.c INCLUDES include)
DeclareCAmkESComponent(GPIO SOURCES components/GPIO/src/gpio.c INCLUDES include)
DeclareCAmkESComponent(SystemTimer SOURCES components/SystemTimer/src/system_timer.c INCLUDES include)

DeclareCAmkESRootserver(pigpio.camkes)
