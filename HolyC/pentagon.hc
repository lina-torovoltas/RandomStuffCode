// compiler used: https://github.com/Jamesbarford/holyc-lang

extern "c" I64 getrandom(U8 *buf, U64 buflen, U32 flags);
extern "c" U0 sleep(U32 seconds);



I64 random_range(I64 min, I64 max) {
    I64 value;

    getrandom(&value, sizeof(I64), 0);

    return min + (value & 0x7FFFFFFFFFFFFFFF) % (max - min + 1);
}


U0 Main() {
    U8 progress = 0;

    while (progress < 100) {
        U8 max = progress + 20;

        if (max > 100){
            max = 100;
        }

        progress = random_range(progress + 1, max);

        "Pentagon hack progress: %d%%\n", progress;

        sleep(1);
    }

    if (random_range(1, 30) > 20) {
        "Pentagon hack: Completed successfully.\n";

    } else {
        "Pentagon hack: Failed.\n";
    }
}

Main;
