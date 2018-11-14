var fs = require('fs');
var path = require('path');

var _this = {
    getPlatform: function() {

        var platformName, os;

        if (process.env) {
            platformName =
                process.env.CORDOVA_PLATFORMS ? process.env.CORDOVA_PLATFORMS.toLowerCase() : undefined;
            os =
                process.env.OS ? process.env.OS.toLowerCase() : undefined;
        }

        return platformName || os;
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
    'isMac': _this.getPlatform().indexOf('window') == -1,
    'root': _this.getRootDir(),
    'currentPath': _this.getCurrentPath(),
}
