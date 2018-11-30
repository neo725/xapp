
# 專案初始化

在完成 repo clone 之後，切換到專案路徑下，執行下列指令

	node _first-time-init.js
	// 如果已經跑過此步驟，後面要再重做，可以加參數 --reset
	// node _first-time-init.js --reset

	gulp

  

gulp 會停在 Finished appjs (或 image:assets, vendorjs 等其他工作項目，因為這幾個項目為非同步執行，有先有後)

接著新增 (或分割) 到其他視窗中執行下列指令進行實建置輸出

  

# for android :

	cordova build android

cordova 如果成功完成，會出現 success 的訊息，並提示 apk 的位置

沒有加上發布版本的參數 (--release)，預設會打包出 debug 版本的 apk，檔案名稱應該會是 **app-debug.apk**

也就是可以使用 Chrome 的 inspect 做實機除錯

程式都沒問題後，接下來就是準備上架

> 在上架 Google Play 前，應該先進行版號的設定，原則上兩個平台 (ios 與 android)
> 的版號盡量保持一致，方便做後續版本確認 如果有特定平台的 bug 需要修正緊急發布，才考慮版號相異的狀況發生
> 但在下一次的功能更新發佈，兩個平台同時做上架時，記得再把版號對齊

如果要上架 Google Play，改執行下列指令

	// (增加版號的使用，非必要項目，請參考後面說明)
	cordova build android -build
	// (打包出 release 發行版本)
	cordova build android --release

第一個 -build 參數的指令，是為了要遞增版號的處理

如果不增加版號，則可以跳過此指令

> 通常要上架前才會增加版號，且不管上架 Google 還是 Apple，版號有增加才能完成上架，否則平台會不給上架

版號遞增的相關邏輯規則請參考 hooks/before_prepare/010_increment_build_number.js

第二個 --release 參數的指令，是為了打包出 release 版本的 apk

此時 cordova 所提示的 apk 檔案名稱應該為 **app-release.apk**

  

# for ios (on mac) :

先用 Xcode 開啟 platforms/ios/大學聯網.xcworkspace

然後在左邊檔案結構的視窗，選擇第一層的 “大學聯網"

中間的 Signing 	會出現紅色警示

把 Team 選在 Chinese Culture University (Company)

然後回到 Terminal，執行指令建置測試

	ionic cordova build ios --device

OK 的話，會出現 ** ARCHIVE SUCCEEDED **

回到 Xcode 做 Archive 打包

在 Xcode 先進行 Product > Build 進行專案建置

> ios 不能直接使用 ipa 安裝，除非有 root，以現在的 ios 版本 10+ 還沒有 root 的狀態，因此不考慮此安裝可能性

如果建置成功，接著進行 Project > Archive

如果 Archive 為 Disable 狀態沒辦法選擇，請確認裝置是否有選在

Generic iOS Device

  

打包（Archive）完成後，到 Window > Organizer 進行 ipa 輸出及 App Store 上架審核

  
# 建置的最後確認
在 android，能 build 成功不等於 app 能正常執行
通常問題會發生在 cordova-plugin-googleplus 與 cordova-plugin-firebase 所要求使用的 google service (包含 play service) 版本需求不相容造成

> 這一類的錯誤，通常會伴隨訊息 Unable to merge dex 的錯誤出現，遇到這類問題，除了參考 Readme.txt
> 中的處理步驟先做簡單排除 萬一還是不行，那版本不相容的問題可能性就比較高，可以參考 build-debug-logs 下的處理紀錄

因此在建置成功後，務必也要在實機上測試，主要要測試 app 開啟正常，Google 登入 與 Facebook 登入也正常


*此文件最後編輯於 2018-11-22 by thchang*
