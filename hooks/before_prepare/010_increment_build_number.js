#!/usr/bin/env node

// Save hook under `project-root/hooks/before_prepare/`
//
// Don't forget to install xml2js using npm
// `$ npm install xml2js`

var fs = require('fs');
var xml2js = require('xml2js');
var sequence = require('run-sequence');
var Confirm = require('prompt-confirm');
var clc = require("cli-color");

var notice = clc.yellow;
var warning = clc.xterm(13);
var info = clc.xterm(33);
var success = clc.green;

console.log(notice('*** 010_increment_build_number.js ***'));

var func_increment = function (is_increment) {
  console.log('[increment_build_number] is_increment = ' + notice(is_increment));

  if (is_increment == false) {
    console.log(warning('[increment_build_number] skip this hook.'));

    return;
  }
  /*

 versionCode = MAJOR * 10000 + MINOR * 100 + PATCH

 ref from:
 https://cordova.apache.org/docs/en/latest/guide/platforms/android/index.html
 Setting the Version Code

 */

  // ios build number
  // Read config.xml
  fs.readFile('config.xml', 'utf8', function (err, data) {
    console.log('-----------------------------------------');
    console.log('Increment config.xml build number for ios');
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

      if (typeof obj.widget.$['ios-CFBundleVersion'] === 'undefined') {
        return console.log('no ios build number setting found.');
      } else {
        var currentBuild = parseInt(obj.widget.$['ios-CFBundleVersion']);

        console.log('Current Build: ', currentBuild);

        // Increment build number
        var targetBuild = currentBuild + 1;

        console.log('Target Build: ', targetBuild);

        obj.widget.$['ios-CFBundleVersion'] = targetBuild;
        console.log(currentBuild + ' -> ' + targetBuild);
      }

      // Build XML from JS Obj
      var builder = new xml2js.Builder();
      var xml = builder.buildObject(obj);

      // Write config.xml
      fs.writeFile('config.xml', xml, function (err) {
        if (err) {
          return console.warn(err);
        }
        console.log(success('config.xml build number for ios successfully incremented'));
      });

    });
  });

  // common version code
  if (is_increment) {
    var calculateVersion = function (versionObj) {
      var major = versionObj.major;
      var minor = versionObj.minor;
      var build = versionObj.build;

      var build_step = Math.floor(build / 100);
      var build_less = build - (100 * build_step);

      minor += build_step;
      build = build_less;

      var minor_step = Math.floor(minor / 10000);
      var minor_less = minor - (10000 * minor_step);

      major += minor_step;
      minor = minor_less;

      return {
        major: major,
        minor: minor,
        build: build
      };
    };

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
          versionObj = calculateVersion(versionObj);
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
          console.log(success('config.xml build number successfully incremented'));
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
        versionObj = calculateVersion(versionObj);
        console.log('Target Version: ', versionObj);
        var targetVersion = versionObj.major + '.' + versionObj.minor + '.' + versionObj.build;
        json.version = targetVersion;
        console.log(currentVersion + ' -> ' + targetVersion);
      }

      // Write package.json
      fs.writeFile('package.json', JSON.stringify(json, null, 4), function (err) {
        if (err) {
          return console.warn(err);
        }
        console.log('package.json build number successfully incremented');
      });
    });
  }
};

if (process && process.env) {
  var cmdline = process.env.CORDOVA_CMDLINE;

  // console.log('[increment_build_number] cmdline :');
  // console.log(process);
  var is_increment = cmdline.indexOf('-build') > -1;

  if (!is_increment) {
    console.log(info('[increment_build_number] if you want to increment version'));
    console.log(info('cordova build android -build'));
    console.log(warning('not "ionic cordova build android -build"'));
    // new Confirm('Do you want to increment version?')
    //   .ask(function (answer) {
    //     var _is_increment = false;

    //     if (answer == 'Y' || answer == 'y') {
    //       _is_increment = true;
    //     }

    //     func_increment(_is_increment);
    //   });
  } else {
    func_increment(is_increment);
  }
}
