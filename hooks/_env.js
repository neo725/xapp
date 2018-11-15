var fs = require('fs');
var path = require('path');
var clc = require("cli-color");

var notice = clc.yellow;

var _this = {
    getPlatform: function() {

        var platformName, os;

        if (process.env) {
            platformName =
                process.env.CORDOVA_PLATFORMS ? process.env.CORDOVA_PLATFORMS.toLowerCase() : undefined;
            os =
                process.env.OS ? process.env.OS.toLowerCase() : undefined;
        }

        var _platform = platformName || os;

        console.log(`platform is : ${notice(_platform)}`);

        return _platform;
    },

    getCurrentPath: function() {
        var platformPathInProject = this.getRootDir();

        //return (fs.existsSync('../../platforms'))
        return platformPathInProject
    },

    getRootDir: function() {

        return process.env.PWD || process.argv[process.argv.length - 1];
    },

}

module.exports = {
    'platform': _this.getPlatform(),
    'isMac': _this.getPlatform().indexOf('mac') != -1,
    'isWindow': _this.getPlatform().indexOf('window') != -1,
    'isAndroid': _this.getPlatform().indexOf('android') != -1,
    'root': _this.getRootDir(),
    'currentPath': _this.getCurrentPath(),
}
