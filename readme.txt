* google firebase 的註冊資訊寫在 firebase-register-readme.txt

* 開發模式運行：
  1. 跑 gulp 做持續建置 (會停在 watch，如果原始碼有改，就會持續做建置)
  2. 執行 ionic serve 跑 chrome 做模擬測試 (不用加 browser platform)

* 在建置的時候，如果要加版號，建置指令參數加 -build
  (ionic cordova build android -build)
  (相關的流程，寫在 /hooks/010_increment_build_number.js )

## [[ 2018-8-19 ]] ##
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

// @ 2018-9-22
// 紀錄一下這個時候我的建置環境
// Android 版本 :
// OS : Windows 10
// IDE : VSCode
// ionic cli 4.1.0
// cordova 8.0.0
// android platform : 7.0
======================================

## [[ 2018-9-22 ]] ##
======================================
@ 問題:
cordova-plugin-firebase 發生 ENOENT: no such file or directory, open '...........\platforms\android\res\values\strings.xml'

  solve ref:
  https://github.com/arnesson/cordova-plugin-firebase/issues/607

  找到 plugins\cordova-plugin-firebase\scripts\after_prepare.js
  修改 ANDROID_DIR
  //var ANDROID_DIR = 'platforms/android';
  var ANDROID_DIR = 'platforms/android/app/src/main';

@ 問題:
No toolchains found in the NDK toolchains folder for ABI with prefix: mips64el-linux-android

  solve:
  確認是否有在 SDK Manager \ SDK Tools 裡面勾選安裝 "NDK"，如有，移除即可

@ 問題:
java.lang.RuntimeException: java.lang.RuntimeException: com.android.builder.dexing.DexArchiveMergerException: Unable to merge dex

  solve:
  移除 android platform 重新加，可以用 rm -rf ./platforms/android 來移除，
  用 cordova platform rm android 是正規的方式，但不知為何會在 removing android from ...... in package.json 停了很久很久
  然後用 cordova platform add android 重新加
======================================
