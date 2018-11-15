#!/usr/bin/env node

var fs = require('fs');
var path = require('path');
var clc = require("cli-color");
var env = require('../_env')

var notice = clc.yellow;
var warning = clc.xterm(13);
var info = clc.xterm(33);

console.log(notice('*** 011_fix_firebase_plugin.js ***'));

// platforms/android 這時候應該要已經安裝好
// 否則後面的作業沒有意義
// 因此條件為判斷是否已經準備好 android 平台

if (!env.isAndroid) {
    console.log(warning('[fix_firebase_plugin] not android platform. skip this hook.'))
    return;
}

// part 1 : 修復 gradle 版本問題
console.log(info('[fix_firebase_plugin] fix part 1 for gradle...'));

//var rootdir = context.opts.projectRoot;
var rootdir = env.root;

var platformDir = 'platforms/android/app';
//change the path to your external gradle file
var srcFile = path.join(rootdir, 'build-extras.gradle');
var destPath = path.join(rootdir, platformDir);
var destFile = path.join(destPath, 'build-extras.gradle');

console.log("copying " + srcFile + " to " + destFile);
if (!fs.existsSync(destPath)) {
    fs.mkdirSync(destPath);
}
fs.createReadStream(srcFile).pipe(fs.createWriteStream(destFile));

// part 2 : 修復 cordova-plugin-firebase 套件新安裝之後，ANDROID_DIR 的問題
console.log(info('[fix_firebase_plugin] now fix part 2 for scripts...'));

var scriptDir = 'plugins/cordova-plugin-firebase/scripts/after_prepare.js';

if (fs.existsSync(scriptDir)) {
    fs.readFile(scriptDir, 'utf8', function(err, data) {
        if (err) {
            throw err;
        }
        var findReg = /var ANDROID_DIR = 'platforms\/android'/g;
        var replaceStr = 'var ANDROID_DIR = \'platforms/android/app/src/main\'';
        var result = data.replace(findReg, replaceStr)

        fs.writeFile(scriptDir, result, 'utf8', function(err) {
            if (err) throw err;
        });
    });
}
