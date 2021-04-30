#include <stdio.h>

#include <platsupport/io.h>
#include <platsupport/gpio.h>
#include <pigpio.h>

#include <camkes.h>

// BCM2835 DS Table 6-1
#define GPIO_FSEL_BASE 0x00
#define GPIO_SET_BASE 0x1c
#define GPIO_CLR_BASE 0x28
#define GPIO_LVL_BASE 0x34

#define GPIO_FSEL_BITS 3

void inf__init(void)
{
}

int inf_select_function(gpio_pin_t pin, gpio_func_t func)
{
    if (pin > GPIO_PIN_LAST) {
        return -1;
    }

    // BCM2835 DS Table 6-2
    volatile uint32_t *fsel_base_addr = (volatile uint32_t *)((uintptr_t)reg + GPIO_FSEL_BASE);
    volatile uint32_t *addr = fsel_base_addr + pin / 10;
    unsigned int offset = GPIO_FSEL_BITS * (pin % 10);
    write_bits(addr, offset, GPIO_FSEL_BITS, func);
}

int inf_read_pin(gpio_pin_t pin)
{
    if (pin > GPIO_PIN_LAST) {
        return -1;
    }

    // BCM2835 DS Table 6-12
    volatile uint32_t *lvl_base_addr = (volatile uint32_t *)((uintptr_t)reg + GPIO_LVL_BASE);
    volatile uint32_t *addr = lvl_base_addr + pin / 32;
    unsigned int offset = pin % 32;
    return read_bits(addr, offset, 1);
}

int inf_write_pin(gpio_pin_t pin, bool val)
{
    if (pin > GPIO_PIN_LAST) {
        return -1;
    }

    // BCM2835 DS Table 6-8,6-10
    uintptr_t base = val ? GPIO_SET_BASE : GPIO_CLR_BASE;
    volatile uint32_t *base_addr = (volatile uint32_t *)((uintptr_t)reg + base);
    volatile uint32_t *addr = base_addr + pin / 32;
    unsigned int offset = pin % 32;
    write_bits(addr, offset, 1, 1);
    return 0;
}
