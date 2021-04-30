#include <stdio.h>

// Generated component header.
#include <camkes.h>

int run(void)
{
    printf("Starting control thread\n");
    gpio_select_function(GPIO_PIN_21, GPIO_FUNC_OUTPUT);

    bool led_on = false;
    while (true) {
        led_on = !led_on;
        gpio_write_pin(GPIO_PIN_21, led_on);
        timer_sleep(1000000000ULL);
    }

    return 0;
}
