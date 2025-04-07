![emergency_food](https://github.com/forsaken-heart24/i_dont_want_to_be_an_weirdo/blob/main/banner_images/emergency_food.png?raw=true)

# Building / Modifying Your Own Stock-Based MOD
**Attention:** This project is solely made for Exynos devices and is not meant for others. Some might work because nothing gets changed much, but still, proceed at your own risk.

## Dependencies:
- Java
- Python (only used in patching recovery)
- wget
- curl
- gcc
**Attention:** You shall not proceed without these dependencies, if you do so. You might end up with a unbootable rom.

## 1️⃣ Configure `makeconfigs.prop`
- Open **`makeconfigs.prop`** in a text editor and adjust the included variables to your preference.
- <a href="https://github.com/forsaken-heart24/HorizonXOneUI-HorizonUX/blob/main/MAKECONFIGS.md">If you're unsure about `makeconfigs.prop`, consider clicking this blue text</a>

## 2️⃣ Configure `genericTargetPropeties.conf`
- if your device is not maintained (<a href="https://github.com/forsaken-heart24/HorizonXOneUI-HorizonUX/blob/main/SUPPORTED_DEVICES.md">Click to check if your device is supported or not</a>), open **`genericTargetPropeties.conf`** in a text editor and adjust the included variables to your preference.
- <a href="https://github.com/forsaken-heart24/HorizonXOneUI-HorizonUX/blob/main/TARGETPROPERTIES.md">If you're unsure about `genericTargetPropeties.conf`, consider clicking this blue text</a>

## 3️⃣ Convert Line Endings (Windows Users Only)
- Run this command in **Git Bash** or **WSL** to ensure compatibility:  
```curl https://raw.githubusercontent.com/forsaken-heart24/HorizonXOneUI-HorizonUX/refs/heads/main/src/conv2unix.sh | bash```

## 4️⃣ Build the ROM
- After editing **`makeconfigs.prop`**, simply run:  
  ```./src/build.sh```
  inside the cloned directory.

---

# Final Steps
- Boot the ROM and test it.
- If you encounter any issues, **feel free to reach out** via my socials on **GitHub**. 🚀