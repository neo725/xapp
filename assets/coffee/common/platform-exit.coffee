module.exports = ['$rootScope', '$ionicPlatform', '$ionicHistory', '$translate', 'plugins', 'navigation',
    ($rootScope, $ionicPlatform, $ionicHistory, $translate, plugins, navigation) ->
        $ionicPlatform.registerBackButtonAction (e) ->
            e.preventDefault()

            confirmCallback = (buttonIndex) ->
                if buttonIndex == 1
                    ionic.Platform.exitApp()
                return

            confirmToExitApp = () ->
                $translate(['title.exit_app', 'message.sure_to_exit_app', 'popup.ok', 'popup.cancel']).then (translator) ->
                    plugins.notification.confirm(
                        translator['message.sure_to_exit_app'],
                        confirmCallback,
                        translator['title.exit_app'],
                        [translator['popup.ok'], translator['popup.cancel']]
                    )

            # Is there a page to go back to ?
            backView = $ionicHistory.backView()

            if backView
                navigation.slide(backView.stateName, backView.stateParams, 'right')
            else
                confirmToExitApp()

            return false
        , 101
]