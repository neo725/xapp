#!/usr/bin/env node

var fs = require('fs');
var path = require('path');
var clc = require("cli-color");

var notice = clc.yellow;
var warning = clc.xterm(13);
var info = clc.xterm(33);

console.log(notice('*** 012_copy_google-services.json.js ***'));

var platformName = '';
if (process.env && process.env.CORDOVA_PLATFORMS)
    platformName = process.env.CORDOVA_PLATFORMS;

if (platformName.toLowerCase() != 'android') {
    console.log(warning('[copy_google-service.json] not android platform. skip this hook.'))
    return;
}

var rootdir = process.argv[process.argv.length - 1];

var platformDir = 'platforms/android/';
//change the path to your external gradle file
var srcFile = path.join(rootdir, 'assets', 'google-services.json');
var destFile = path.join(rootdir, platformDir, 'google-services.json');

console.log("copying " + srcFile + " to " + destFile);
fs.createReadStream(srcFile).pipe(fs.createWriteStream(destFile));