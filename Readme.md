# 專案初始化
在完成 repo clone 之後，切換到專案路徑下，執行下列指令

    node _first-time-init.js

    cordova prepare

    cordova build android

    gulp

gulp 會停在 Finished appjs (或 image:assets, vendorjs 等其他工作項目，因為這幾個項目為非同步執行，有先有後)
接著新增 (或分割) 到其他視窗中執行下列指令進行實體機測試

    cordova run android

主要要測試 app 開啟正常，Google 登入 與 Facebook 登入也正常