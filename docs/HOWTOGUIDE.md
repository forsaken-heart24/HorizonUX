![emergency_food](https://github.com/forsaken-heart24/i_dont_want_to_be_an_weirdo/blob/main/banner_images/emergency_food.png?raw=true)

# Building or Modifying Your Own Stock-Based MOD

**Disclaimer:** This project is designed exclusively for Exynos and Snapdragon devices. While it may work on other devices due to minimal changes, proceed at your own risk.

---

## Prerequisites

Ensure the following dependencies are installed before proceeding:

- **Java**
- **Python**
- **aria2c**
- **Android NDK**

**Warning:** Missing any of these dependencies may result in an unbootable ROM.

---

## Steps to Build or Modify the ROM

### 1️⃣ Configure `src/makeconfigs.prop`

- Open the file **`src/makeconfigs.prop`** in a text editor.
- Adjust the variables to suit your preferences.
- [Need help? Click here for detailed guidance on `makeconfigs.prop`.](https://github.com/forsaken-heart24/HorizonXOneUI-HorizonUX/docs/MAKECONFIGS.md)

---

### 2️⃣ Configure `src/genericTargetPropeties.conf`

- If your device is not officially supported ([Check supported devices here](https://github.com/forsaken-heart24/HorizonXOneUI-HorizonUX/docs/SUPPORTED_DEVICES.md)), open **`src/genericTargetPropeties.conf`** and make the necessary adjustments.
- If your device is officially supported, no changes are required.
- [Need help? Click here for detailed guidance on `genericTargetPropeties.conf`.](https://github.com/forsaken-heart24/HorizonXOneUI-HorizonUX/docs/TARGETPROPERTIES.md)

---

### 3️⃣ Build the ROM

- To build the ROM, provide either:
  - A URL to the firmware package, or
  - The path to a locally saved firmware file.

- Use the following command in a terminal or command prompt:
  ```bash
  ./src/build.sh <link_to_firmware_online> | <path_to_firmware_on_your_computer>
  ```
  - Replace `<link_to_firmware_online>` with the firmware package URL.
  - Replace `<path_to_firmware_on_your_computer>` with the local file path.

- If everything is pre-configured, you can simply run:
  ```bash
  ./src/build.sh
  ```

**Important:** Verify that the firmware package matches your device model. Using incompatible firmware can cause severe issues.

---

### 4️⃣ Test the ROM

- Boot the ROM and thoroughly test it.
- If you encounter any issues, [reach out via socials mentioned in my Git](https://github.com/forsaken-heart24)

---

**Note:** Always back up your data before proceeding with any modifications.