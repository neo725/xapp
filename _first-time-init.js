var fs = require('fs')
var path = require('path')

var exec = require('child_process').exec
var env = require('./hooks/_env')

require('child_process').execSync('npm i cli-color --save-dev', {stdio: [0, 1, 2]})

var clc = require("cli-color")

var error = clc.red;
var notice = clc.yellow;
var warning = clc.xterm(13);
var info = clc.xterm(33);

// remark all line in build-extra.gradle about com.google....
// add this line : force 'com.android.support:support-v4:27.+'

var _scripts = [
    'cp ./assets/config/android/package.json ./package.json',
    'cp ./assets/config/android/config.xml ./config.xml',

    'npm i --save-dev xml2js chalk run-sequence prompt-confirm cli-color',
    'npm i',

    'mkdir plugins',

    'cordova platform add android@latest',
]

console.log(notice('*** first time init ***'))

var pluginsDir = path.join(env.root, 'plugins')

if (fs.existsSync(pluginsDir)) {
    console.log(info('\'plugins\' is already exists in project, maybe this is not your first time to run this script?'))
    return
}

_scripts.forEach((script) => {
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

    console.log(`prepare to run [${info(script)}] ...`)
    require('child_process').execSync(script, {stdio: [0, 1, 2]})
})
