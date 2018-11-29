var fs = require('fs')
var path = require('path')

var exec = require('child_process').exec

require('child_process').execSync('npm i cli-color --save-dev', {stdio: [0, 1, 2]})

var clc = require("cli-color")
var env = require('./hooks/_env')

var error = clc.red;
var notice = clc.yellow;
var warning = clc.xterm(13);
var info = clc.xterm(33);

if (process.argv.filter(v => v == '--reset').length > 0) {
    require('child_process').execSync('rm -rf platforms', {stdio: [0, 1, 2]})
    require('child_process').execSync('rm -rf plugins', {stdio: [0, 1, 2]})
    
}

console.log(`env.platform : ${notice(env.platform)}`)
console.log(`env.isMac : ${notice(env.isMac)}`)

// remark all line in build-extra.gradle about com.google....
// add this line : force 'com.android.support:support-v4:27.+'

var _scripts = [
    { android: 'cp ./assets/config/android/package.json ./package.json', ios: 'cp ./assets/config/ios/package.json ./package.json' },
    { android: 'cp ./assets/config/android/config.xml ./config.xml', ios: 'cp ./assets/config/ios/config.xml ./config.xml' },

    { mac: '_prepare_for_ios.js' },

    'npm install cordova-res-generator -g',
    'npm i --save-dev xml2js chalk run-sequence prompt-confirm cli-color',
    'npm i',

    'mkdir plugins',

    { android: 'cordova platform add android@7.1.2', ios: 'cordova platform add ios@4.4.0' },

]

console.log(notice('*** first time init ***'))

var pluginsDir = path.join(env.root, 'plugins')

if (fs.existsSync(pluginsDir)) {
    console.log(info('\'plugins\' is already exists in project, maybe this is not your first time to run this script?'))
    console.log(notice('If you want to reset all setting do a clean startup, please run \'node _first-time-init.js --reset\''))
    return
}

var _run = (script, next) => {
    dir = exec(script, function(err, stdout, stderr) {
        console.log('call finished !')
        if (err) {
            return console.log(error(err))
        }

        console.log(stdout)
    })

    dir.on('exit', function(code) {
        console.log('exit !')

        if (next) {
            next(code)
        }
    })
}

_scripts.forEach((script) => {
    var testIsObject = (target) => {
        let _type = typeof(target)

        if (_type == 'object') return true;

        if (_type.indexOf('object') > -1) return true;

        return false
    }
    try
    {
        if (testIsObject(script)) {
            script = script[env.platform]
            console.log(`script : ${notice(script)}`)
            console.log(`platform is : ${notice(env.platform)}`)
        }

        let scriptUnavailable = (!script || script == undefined || script == '')

        // if (scriptUnavailable) {
        //     console.log(error(`script defined in scripts (index = ${_index}) has not available setting !`))
        // }
        if (!scriptUnavailable) {
            console.log(`prepare to run [${info(script)}] ...`)

            if (script.endsWith('.js')) {
                script = `node ${script}`
            }
            require('child_process').execSync(script, {stdio: [0, 1, 2]})
        }

        _index++
    }
    catch (err) {
        console.log(error('error maybe happen :'))
        console.log(err.status)
        console.log(err.message)
        console.log(err.stderr)
        console.log(err.stdout)
        console.log('')
    }
})

console.log(notice('there are usually happen plugin install failed.'))
console.log(notice('especially on \'phonegap-mobile-accessibility\''))
console.log(notice('here is snippets for plugin install in manual :'))
console.log('')
console.log('cordova plugin add https://github.com/phonegap/phonegap-mobile-accessibility.git')
console.log('')