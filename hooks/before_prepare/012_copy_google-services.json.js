#!/usr/bin/env node

var fs = require('fs');
var path = require('path');
var clc = require("cli-color");
var env = require('../_env')

var notice = clc.yellow;
var warning = clc.xterm(13);
var info = clc.xterm(33);

console.log(notice('*** 012_copy_google-services.json.js ***'));

// platforms/android 這時候應該要已經安裝好
// 否則後面的作業沒有意義
// 因此條件為判斷是否已經準備好 android 平台

if (!env.isAndroid) {
    console.log(warning('[012_copy_google-services.json] not android platform. skip this hook.'))
    return;
}

var rootdir = env.root;

var platformDir = 'platforms/android/app';

//change the path to your external gradle file
var srcFile = path.join(rootdir, 'assets', 'google-services.json');

var platformDir = path.join(rootdir, 'platforms/android/app');
var destFile = path.join(platformDir, 'google-services.json');

console.log(platformDir);
console.log(destFile);

if (fs.existsSync(rootdir, platformDir) == false) {
    fs.mkdirSync(rootdir, platformDir);
}

console.log("copying " + srcFile + " to " + destFile);
fs.createReadStream(srcFile).pipe(fs.createWriteStream(destFile));
