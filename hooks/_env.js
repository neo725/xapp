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

        if (process.platform && os == undefined) {
            // if platform is darwin that means user os is mac
            // in other case i don't think about it to run this process
            // so in last if not darwin then throw a undefined back.
            os = process.platform == 'darwin' ? 'ios' : undefined;
        }

        console.log(notice('** process.platform **'))
        console.log(process.platform)
        console.log('.')
        console.log('.')
        console.log(notice('** process.env **'))
        console.log(process.env)
        console.log('.')
        console.log('.')
        console.log(notice('** process.argv **'))
        console.log(process.argv)
        console.log('.')
        console.log('.')
        console.log('.')
        console.log('.')

        var _root = this.getRootDir();
        if (fs.existsSync(path.join(_root, '/platforms/android'))) {
            // project has already install android platform
            platformName = 'android'
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
