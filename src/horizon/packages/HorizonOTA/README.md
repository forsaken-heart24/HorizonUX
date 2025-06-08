![Banner](https://github.com/pachdomenic/TukiRom-OTA/blob/m31/img/icon.png?raw=true)
=====

This repo contains 십 Update app.

Please notice the app needs external edits to the following files in order to enable the "parentIsDeviceDefault" bool in frameworks (this one enables some little UI elements like ToolbarPopup & EdgeEffect):

> reference xmls: /res/values/styles.xml
> /res/values-v25/styles.xml

## To compile (Java should be present):
- Edit the makefile keystore variables to sign the package with your own key.
- Use SkipSign=false if you wanna skip signing the package, otherwise set it to true if you want to sign it.
```bash
cd HorizonUX
make OTA_MANIFEST_URL=<your own ota manifest url> SkipSign=true|false UN1CAUpdater
```