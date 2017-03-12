constants = require('../common/constants')

module.exports = [
    '$cordovaDevice', '$document',
    ($cordovaDevice, $document) ->

        onDeviceReady = ->
            findDeviceName = (model) ->
                device = _.find(constants.DEVICEMODEL_MAPPING, { 'model': model })
                if device
                    return device.deviceName
                return ''

            model = $cordovaDevice.getModel().toLowerCase()
            deviceName = findDeviceName(model)
            $document.find('body').addClass(deviceName)

        document.addEventListener('deviceready', onDeviceReady, false)
]