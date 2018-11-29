#!/usr/bin/env node

// this file should only be run in mac os
var fs = require('fs')
var clc = require("cli-color")
var xml2js = require('xml2js');

var env = require('./hooks/_env')

var error = clc.red;
var notice = clc.yellow;
var warning = clc.xterm(13);
var info = clc.xterm(33);

// this step used to change package id from 'tw.edu.pccu.sce.sceapp' to 'tw.edu.pccu.sce.sceapp-prod'
// because package id in ios is 'tw.edu.pccu.sce.sceapp-prod'

fs.readFile('config.xml', 'utf8', function (err, data) {
    console.log('-----------------------------------------');
    console.log('customize tweak for ios runs in _prepare_for_ios.js');
    console.log('');

    if (err) {
        console.log('Error happend while open config.xml :')
        return console.log(error(err));
    }

    // Get XML
    var xml = data;

    // Parse XML to JS Obj
    xml2js.parseString(xml, function (err, result) {
        if (err) {
            console.log('Error happend while parse from xml to json object :')
            return console.warn(err);
        }

        // Get JS Obj
        var obj = result;

        // change widget id to 'tw.edu.pccu.sce.sceapp'
        if (typeof obj.widget.$['id'] === 'undefined') {
            return console.log('no widget id setting found.');
        }

        var id = obj.widget.$['id']

        if (id.indexOf('-prod') == -1) {
            id = id + '-prod'

            obj.widget.$['id'] = id
        }

        // remove android section in config.xml (/widget/platform[name=android])
        if (obj.widget.platform && Array.isArray(obj.widget.platform)) {
            obj.widget.platform.forEach((platform, index) => {
                if (platform.$['name'] == 'android') {
                    console.log('platform with android found !')
                    obj.widget.platform.splice(index, 1)
                    return
                }
            })
        }

        // Build XML from JS Obj
        var builder = new xml2js.Builder();
        var xml = builder.buildObject(obj);

        // Write config.xml
        fs.writeFile('config.xml', xml, function (err) {
            if (err) {
                return console.warn(err);
            }
        });
    });
})
