![emergency_food](https://github.com/forsaken-heart24/i_dont_want_to_be_an_weirdo/blob/main/banner_images/emergency_food.png?raw=true)


# To compile(Android NDK should be present):
```
cd HorizonUX/src
make bootloop_saviour
```

# Build Errors:
- ignore the non-critical ones and drop a comment if it's critical

# Tinkering stuffs:
- look into the code and mod it in your way, if you find any bugs please do a pull-request. Thanks :D

## What Does This Do?
- This init daemon disables all Magisk modules if the Zygote process has a different PID (process id) every 5 seconds
- Helpful for recovering from bootloops caused by unstable modules.