# 1. Connect Samsung A24 to Mac OS via USB 

- Developer Options -Tap Build Info 7 times
- Turn on USB Debugging on phone
- 

# 2. adb

Copy klz_vault to  Documents folder
```bash
  ╱  ~/Documents  adb devices -l                                                                                                                                                                             ✔ ╱ base  ╱ at 11:19:54  
List of devices attached
R58W502985Z            device usb:3-1.1 product:a24nsxx model:SM_A245F device:a24 transport_id:3


  ╱  ~/Documents  adb shell rm -fr /sdcard/Documents/klz_vault/                                                                                                                                              ✔ ╱ base  ╱ at 11:19:59  


  ╱  ~/Documents  adb push klz_vault /sdcard/Documents                                                                                                                                                       ✔ ╱ base  ╱ at 11:20:02  

klz_vault/: 682 files pushed, 0 skipped. 1.0 MB/s (20904008 bytes in 19.889s)

  ╱  ~/Documents 
```


# 3. Android Osidian

- Open folder as Vault (point to klz_vault folder) -> Use This folder 

# 4. Save Github Personal Access Token 

- https://github.com/fimtestxyz/klz_vault
		- Profile Icon -> Settings -> Developer Settings -> Personal Access Token (token classic) -> check repo


Techshrimp # Obsidian邪修用法，免费云同步，AI，手机端，还有进阶技巧
 timestamp 15:08
![personal access token|600](assets/Obsidian%20-%20Config%20to%20sync%20on%20Android%20phone/file-20251227112939192.png)\

![github|600](assets/Obsidian%20-%20Config%20to%20sync%20on%20Android%20phone/file-20251227113426898.png)