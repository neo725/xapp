* google firebase 的註冊資訊寫在 firebase-register-readme.txt
https://console.firebase.google.com/u/0/?hl=zh-TW

* 第一次拉下專案，在 Windows 及 Mac 分別作下面兩件事情
[Android]
1. 將 /assets/config/android 的 config.xml 以及 package.json 複製到專案根目錄下

[iOS]
1. 將 /assets/config/ios 的 config.xml 以及 package.json 複製到專案根目錄下

[Android + iOS]
2. 將終端機視窗開兩個分割，最好是左右分割
3. 左邊先運行 npm i，安裝 node components

[Android]
4. ionic cordova platform add android@6.4.0
5. cordova build android
6. 如果成功，要跑測試安裝到手機上的話，運行 cordova run android

[ios]
4. ionic cordova platform add ios
5. cordova prepare
6. 切換到 XCode，開啟 /platforms/ios/大學聯網.xcodeproj
7. 先跑建置，確定可以完成後，連接手機到 Mac 上，選擇裝置到手機，按執行按紐 (撥放三角形)

如果運行測試沒問題，要做發布的話

[Android]
1. 增加版本號，執行 cordova prepare --build
2. 執行 cordova build android --release
3. 完成後，將提示的 apk 上傳到 Google Play Console
https://developer.android.com/distribute/console/
(登入帳號密碼在下面找 上架)

[ios]
1. 增加版本號，執行 cordova build ios --build (如果有發生問題，參考下面找 ionic cordova build ios)
2. 執行 cordova prepare
3. 到 Xcode 跑 ARCHIVE
4. 完成後，到 Window\Organizer，剛才 archive 跑出來的版號應該要出現在第一筆
5. 點要上傳的版本，點 Upload to App Store
6. 到 iTunes Connect 發布版號
https://itunesconnect.apple.com/login
(登入帳號密碼在下面找 上架)


* 開發模式運行：
  1. 跑 gulp 做持續建置 (會停在 watch，如果原始碼有改，就會持續做建置)
  2. 執行 ionic serve 跑 chrome 做模擬測試 (不用加 browser platform)

* 在建置的時候，如果要加版號，建置指令參數加 -build
  (cordova prepare --build)
  (相關的流程，寫在 /hooks/010_increment_build_number.js )

* 常常在新增完套件後，或是某些情況，在建置 android 版本出現 java 相關錯誤
  可以先嘗試把 android platform 移除重加

* Google Play 上架
  帳號：developer@sce.pccu.edu.tw
  密碼：可以問 [博安] 或 [琮華]
  登入後，如果出現 "您的帳戶已變更" 的畫面，並要您選擇哪一種類型的帳號，點 "稍後再進行"

* Apple 上架 (iTunes Connect)
  帳號密碼同 Google Play

* Android SDK 版本清單 #version #sdk
https://source.android.com/setup/start/build-numbers

## [[ 2018-8-19 ]] ##
======================================
把 ionic-cli 更新到最新版，然後有提示安裝 ionic-cli v1
都裝好之後，platform + android 最新版本
可以建置

// == 以下是 Android 版本的操作 ==
// 先開一個 bash 進行打包資源 (css, js, images...)
gulp

// 另外開一個 bash 執行 app 測試
ionic cordova run android

// 建置並增加版號
cordova build android --build

// 建置發行版本
ionic cordova build android --release

// == 以下是 iOS 版本的操作 ==
// 用 VSCode 開 bash 進行資源打包
gulp

// 另外開一個 bash 執行 cordova 以及 XCode 建置，也可以選擇下面 prepare 把 cordova 所需檔案複製到 platform 中
ionic cordova build ios
// 如果出現 Code Signing Error 導致失敗，先跑下面 XCode 確認 Signing 是否正確
// 如果有成功完成，最後會出現 ** ARCHIVE SUCCEEDED ** 或 ** EXPORT SUCCEEDED ** 的訊息

// build 完之後，用 XCode 開專案，確認一下 General / Signing / Team 是選在 Chinese Culture University (Company)
// 選單 > Product > Build 進行專案建置

// 如果只想跑 cordova 建置，再轉到 XCode 去執行 App 到手機，可以不用跑上面 build ios 的指令，這樣操作會比較快
cordova prepare

// 如果在跑上面建置的指令
// 沒有跑到 Discovered plugin，在前面的 hook 跑完後就發生 Error: spawn EACCES 之類的錯誤訊息
// 原因：sceapp 資料夾權限問題，將 sceapp 這個專案資料夾用 chmod 修改權限
// 解決：sudo chmod -R a+rwx sceapp
//
// 如果有做上面權限的操作 (chmod)，記得設定讓 git 忽略檔案權限的異動
// 不然全部的檔案都會變成異動狀態
// 指令如下：(要回到 sceapp 資料夾下)
// git config core.fileMode false

// iOS 版本的 Bundle identifier 是 tw.edu.pccu.sce.sceapp-prod


// @ 2018-9-22
// 紀錄一下這個時候我的建置環境
// Android 版本 :
// OS : Windows 10
// IDE : VSCode
// ionic cli 4.1.0
// cordova 8.0.0
// android platform : 7.0
//
// iOS 版本 :
// OS : macOS High Sierra (10.13.5)
// IDE : VSCode + XCode
// ionic cli 2.1.4
// cordova 6.5.0
// ios platform : 4.3.1

// @ 2018-9-22
// Google 登入用 cordova-plugin-googleplus 做的
// #google #sso
// https://github.com/EddyVerbruggen/cordova-plugin-googleplus
cordova plugin add cordova-plugin-googleplus --save --variable REVERSED_CLIENT_ID=com.googleusercontent.apps.417861383399-r7rtkqljs87ffbubtkrtah4liktvucu1 --variable WEB_APPLICATION_CLIENT_ID=417861383399-r7rtkqljs87ffbubtkrtah4liktvucu1.apps.googleusercontent.com
ionic cordova plugin add cordova-plugin-googleplus --variable REVERSED_CLIENT_ID=com.googleusercontent.apps.417861383399-r7rtkqljs87ffbubtkrtah4liktvucu1
======================================

## [[ 2018-9-22 ]] ##
======================================
@ 建置問題:
cordova-plugin-firebase 發生 ENOENT: no such file or directory, open '...........\platforms\android\res\values\strings.xml'

  solve ref:
  https://github.com/arnesson/cordova-plugin-firebase/issues/607

  找到 plugins\cordova-plugin-firebase\scripts\after_prepare.js
  修改 ANDROID_DIR
  //var ANDROID_DIR = 'platforms/android';
  var ANDROID_DIR = 'platforms/android/app/src/main';

  !! 補充 !!
  後來把這段修正寫到 hooks/before_build/011_fix_firebase_plugin.js 了
  建置時會自動修正，不用手動處理了

@ 建置問題:
No toolchains found in the NDK toolchains folder for ABI with prefix: mips64el-linux-android

  solve:
  確認是否有在 SDK Manager \ SDK Tools 裡面勾選安裝 "NDK"，如有，移除即可

@ 建置問題:
java.lang.RuntimeException: java.lang.RuntimeException: com.android.builder.dexing.DexArchiveMergerException: Unable to merge dex

  找到一個新方法處理，先試底下的 solve 1，如果還是不行，在試 solve 2

  solve 1:
  執行 cordova clean，然後重新跑一次 cordova build android

  solve 2:
  移除 android platform 重新加，可以用 rm -rf ./platforms/android 來移除，
  用 cordova platform rm android 是正規的方式，但不知為何會在 removing android from ...... in package.json 停了很久很久
  然後用 cordova platform add android@6.4.0 重新加

@ 套件問題:
Google SSO 登入無法使用
  點了 Google 登入之後，程式有 googleplus，也叫了 login
  但是沒有反應，也沒切登入畫面

  solve:
  可能是 google gms play-service 相關套件的版本問題
  參考 https://github.com/EddyVerbruggen/cordova-plugin-googleplus/issues/484

  已經有寫了 before_build 的 hook : 011_fix_firebase_plugin.js
  主要是複製專案根目錄下的 build-extra.grade 到 platforms/android/app
  強制指定版本 1.18

@ 套件問題:
安裝 cordova-plugin-firebase 出現錯誤
Uh oh!
"......" already exists!

  solve:
  移除掉 android platform，重新再加
  rm -rf ./platforms/android
  ionic cordova platform add android@6.4.0
  ionic cordova build android
======================================

## [[ 2018-10-15 ]] ##
======================================
@ mobile-pull-to-refresh 套件會用到的指令
  npm uninstall mobile-pull-to-refresh --save-dev
  npm i git+https://github.com/neo725/pull-to-refresh --save-dev

  (gulp 要重 run)
  (等到出現 Finished 'image:assets'...... 才跑下面的指令)

  ionic cordova run android
======================================

@ iOS platform 重新安裝後，遇到的一些問題
  1. 有問題無法正常安裝的 cordova plugin
     cordova plugin add cordova-plugin-x-socialsharing@5.1.8
     cordova plugin add https://github.com/phonegap/phonegap-mobile-accessibility.git
