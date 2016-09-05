en_us = require('./en-us')()
zh_hans = require('./zh-hans')()
zh_hant = require('./zh-hant')()

module.exports = ->
  {
    'en-US': en_us,
    'zh-Hans': zh_hans,
    'zh-Hant': zh_hant
  }
