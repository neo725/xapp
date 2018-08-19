* google firebase 的註冊資訊寫在 firebase-register-readme.txt
* 開發模式運行：
  1. 跑 gulp 做持續建置 (會停在 watch，如果原始碼有改，就會持續做建置)
  2. 執行 ionic serve 跑 chrome 做模擬測試 (不用加 browser platform)
======================================

2018-8-19
======================================
把 ionic-cli 更新到最新版，然後有提示安裝 ionic-cli v1
都裝好之後，platform + android 最新版本
可以建置

// 先開一個 bash 進行打包資源 (css, js, images...)
gulp

// 另外開一個 bash 執行 app 測試
ionic cordova run android

// 建置並增加版號
ionic cordova build android --build

// 建置發行版本
ionic cordova build android --release
======================================
