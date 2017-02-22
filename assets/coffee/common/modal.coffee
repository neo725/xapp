module.exports = ['$ionicPlatform', '$timeout', '$ionicModal', '$ionicLoading', '$ionicPopup', '$translate'
    ($ionicPlatform, $timeout, $ionicModal, $ionicLoading, $ionicPopup, $translate) ->
        showLoadingSpinner = (title, message) ->
#            #ion-spinner style
            opts =
                template: '<ion-spinner></ion-spinner>'
                noBackdrop: true
                duration: 10000
            $ionicLoading.show opts
            return
            $ionicPlatform.ready ->
                $translate([title, message]).then (translation) ->
                    if window.plugins
                        window.plugins.spinnerDialog.show(
                            translation[title]
                            translation[message]
                        )
#                        window.plugins.spinnerDialog.show(
#                            translation[title],
#                            translation[message],
#                            true
#                        )

        hideLoadingSpinner = ->
            $ionicLoading.hide()
            return
            $ionicPlatform.ready ->
                if window.plugins
                    $timeout(() ->
                        window.plugins.spinnerDialog.hide()
                    )

        generateModel = (scope, templateId, onSuccess) ->
            $ionicModal.fromTemplateUrl(templateId, onSuccess,
                {
                    'animation': 'slide-in-up'
                    'scope': scope
                    'backdropClickToClose': false
                })

        showMessage = (message, timeout) ->
            timeout = timeout || 3000
            $translate(message).then (text) ->
                $ionicLoading.show({
                    template: text,
                    noBackdrop: true,
                    duration: timeout
                })

        showLongMessage = (message) ->
            showMessage(message, 5000)

        showTopMessage = (message, params) ->
            $translate(message, params).then (text) ->
                $ionicLoading.show({
                    template: '<div class="top-message">' + text + '</div>'
                    noBackdrop: true,
                    duration: 3000
                })

                $timeout(->
                    $($('.top-message')[0]).parent().addClass('top-message-container')
                )

        showConfirm = (message, onConfirm, onCancel = (->), okText = 'popup.ok', cancelText = 'popup.cancel') ->
            $translate([message, okText, cancelText]).then (translation) ->
                confirmPopup = $ionicPopup.confirm({
                    template: translation[message],
                    cancelText: translation[cancelText],
                    okText: translation[okText]
                })
                confirmPopup.then((confirmed) ->
                    if confirmed
                        onConfirm()
                    else
                        onCancel()
                )

        checkNetwork = (func, message) ->
            if (navigator.connection and navigator.connection.type in [Connection.CELL_2G, Connection.CELL_3G,
                Connection.CELL_4G, Connection.CELL])
                confirm(message, func)
            else
                func()

        openInApp = (url, para) ->
            $translate('button.cancel').then (text) ->
                if para
                    window.open(url, '_blank', "closebuttoncaption=#{text},location=no,#{para}")
                else
                    window.open(url, '_blank', "closebuttoncaption=#{text},location=no,enableViewportScale=yes")

        return {
            showLoading: showLoadingSpinner
            hideLoading: hideLoadingSpinner
            showMessage: showMessage
            showLongMessage: showLongMessage
            generate: generateModel
            showTopMessage: showTopMessage
            showConfirm: showConfirm
            checkNetwork: checkNetwork
            openInApp: openInApp
        }
]
