#!/usr/bin/env node

// Save hook under `project-root/hooks/before_prepare/`
//
// Don't forget to install xml2js using npm
// `$ npm install xml2js`

var fs =        require('fs');
var xml2js =    require('xml2js');
var sequence =  require('run-sequence');

var cmdline = process.env.CORDOVA_CMDLINE;

var is_increment = cmdline.indexOf('-build');

/*

 versionCode = MAJOR * 10000 + MINOR * 100 + PATCH

 ref from:
 https://cordova.apache.org/docs/en/latest/guide/platforms/android/index.html
 Setting the Version Code

 */

if (is_increment > -1) {
    // Read config.xml
    fs.readFile('config.xml', 'utf8', function (err, data) {
        console.log('-----------------------------------------');
        console.log('Increment config.xml build number');
        if (err) {
            return console.log(err);
        }

        // Get XML
        var xml = data;

        // Parse XML to JS Obj
        xml2js.parseString(xml, function (err, result) {
            if (err) {
                return console.warn(err);
            }

            // Get JS Obj
            var obj = result;

            if (typeof obj.widget.$.version === 'undefined') {
                obj.widget.$.version = '0.0.1';
            } else {
                var currentVersion = obj.widget.$.version;
                var curVer = String(obj.widget.$.version).split('.');
                var versionObj = {
                    major: Number(curVer[0]),
                    minor: Number(curVer[1]),
                    build: Number(curVer[2])
                };
                console.log('Current Version: ', versionObj);
                // Increment build numbers
                versionObj.build += 1;
                console.log('Target Version: ', versionObj);
                var targetVersion = versionObj.major + '.' + versionObj.minor + '.' + versionObj.build;
                obj.widget.$.version = targetVersion;
                console.log(currentVersion + ' -> ' + targetVersion);
            }

            // Build XML from JS Obj
            var builder = new xml2js.Builder();
            var xml = builder.buildObject(obj);

            // Write config.xml
            fs.writeFile('config.xml', xml, function (err) {
                if (err) {
                    return console.warn(err);
                }
                console.log('config.xml build number successfully incremented');
            });

        });
    });

    fs.readFile('package.json', 'utf8', function (err, data) {
        console.log('-----------------------------------------');
        console.log('Increment package.json build number');
        if (err) {
            return console.warn(err);
        }

        // Get JSON
        var json = JSON.parse(data);

        if (typeof json.version === 'undefined') {
            json.version = '0.0.1';
        } else {
            var currentVersion = json.version;
            var curVer = String(json.version).split('.');
            var versionObj = {
                major: Number(curVer[0]),
                minor: Number(curVer[1]),
                build: Number(curVer[2])
            };
            console.log('Current Version: ', versionObj);
            // Increment build numbers
            versionObj.build += 1;
            console.log('Target Version: ', versionObj);
            var targetVersion = versionObj.major + '.' + versionObj.minor + '.' + versionObj.build;
            json.version = targetVersion;
            console.log(currentVersion + ' -> ' + targetVersion);
        }

        // Write package.json
        fs.writeFile('package.json', JSON.stringify(json, null, 4), function (err) {
            if (err) { return console.warn(err); }
            console.log('package.json build number successfully incremented');
        });
    });
}