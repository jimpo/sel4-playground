#include <platsupport/plat/system_timer.h>

#include <camkes.h>


system_timer_t timer[1];

void inf__init(void)
{
    int ret;

    system_timer_config_t config = { .vaddr = reg };
    ret = system_timer_init(timer, config);
    ZF_LOGF_IF(ret != 0, "system_timer_init failed");
}

int inf_sleep(uint64_t ns)
{
    int ret;

    uint64_t now_ns = system_timer_get_time(timer);
    ret = system_timer_set_timeout(timer, now_ns + ns);
    if (ret < 0)
        return ret;

    ret = sem_wait();
    ZF_LOGF_IF(ret != 0, "sem_wait failed");

    return 0;
}

void irq_handle(void)
{
    int ret;

    ret = system_timer_handle_irq(timer);
    ZF_LOGF_IF(ret != 0, "system_timer_handle_irq failed");

    ret = sem_post();
    ZF_LOGF_IF(ret != 0, "sem_post failed");

    irq_acknowledge();
}
