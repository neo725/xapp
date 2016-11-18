constants = require('../common/constants')

module.exports = [
    '$rootScope', '$scope', '$ionicHistory', '$ionicModal', '$cordovaAppVersion', '$cordovaCamera', '$timeout', 'modal', 'navigation', 'api',
    ($rootScope, $scope, $ionicHistory, $ionicModal, $cordovaAppVersion, $cordovaCamera, $timeout, modal, navigation, api) ->
        $scope.user = {}
        $scope.notify = constants.DEFAULT_NOTIFICATION_SETTING

        $scope.goBack = ->
            navigation.slide 'home.dashboard', {}, 'right'

        $scope.goWishList = ->
            navigation.slide 'home.member.wish', {}, 'left'

        $scope.goOrderList = ->
            navigation.slide 'home.member.order', {}, 'left'

        $scope.goFinishList = ->
            navigation.slide 'home.member.finish', {}, 'left'

        $scope.goMessageList = ->
            navigation.slide 'home.member.message', {}, 'left'

        $scope.goEdit = ->
            $scope.modalFunction.hide()
            $timeout(->
                navigation.slide 'home.member.edit', {}, 'up'
            )

        $scope.goSuggest = ->
            $scope.modalFunction.hide()
            $timeout(->
                navigation.slide 'home.member.suggestion', {}, 'up'
            )

        $scope.toggleNotification = ($event) ->
            $event.stopPropagation()
            if $scope.notify == 't'
                $scope.notify = 'f'
            else
                $scopeg.notify = 't'

        $scope.checkNotificationIsChecked = ->
            if $scope.notify != 'f'
                $scope.notify = 't'
            return $scope.notify == 't'

        $scope.takePicture = ->
            options =
                quality: 50
                destinationType: Camera.DestinationType.DATA_URL
                sourceType: Camera.PictureSourceType.CAMERA
                allowEdit: false
                encodingType: Camera.EncodingType.JPEG
                targetWidth: 200
                targetHeight: 200
                saveToPhotoAlbum: false
                correctOrientation: true

            $cordovaCamera.getPicture(options).then (imageData) ->
                    $scope.avatars = imageData
                    $('#user-avatars').attr 'src', 'data:image/jpeg;base64,' + $scope.avatars
                    $timeout ->
                        $avatars = $('#user-avatars');
                        w = $avatars.width()
                        h = $avatars.height()
                        $avatars.css('max-width', '')
                        $avatars.css('max-height', '')
                        if h > w
                            $avatars.css('max-width', '100px')
                        else
                            $avatars.css('max-height', '100px')
                    , 100
                , (error) ->
                    console.log error

        $scope.logout = ->
            $scope.modalFunction.hide()
            $rootScope.logout()

        loadData = ->
            loadUserSetting = ->
                onSuccess = (response) ->
                    if (response != null)
                        $scope.notify = response.para_value
                    modal.hideLoading()

                onError = (error, status_code) ->
                    console.log status_code
                    console.log error
                    modal.hideLoading()

                api.getUserSetting 'notify', onSuccess, onError

            onSuccess = (data) ->
                $scope.user = data
                loadUserSetting()

            onError = (error, status_code) ->
                console.log status_code
                console.log error
                loadUserSetting()

            $rootScope.getMemberData(onSuccess, onError)

        $scope.$on('$ionicView.enter', ->
            loadData()
        )

        # version number record in config.xml that under project root
        document.addEventListener('deviceready', () ->
            $cordovaAppVersion.getVersionNumber().then (version)->
                $scope.app_version = version
        , false)

        $ionicModal.fromTemplateUrl('templates/modal-function.html',
            scope: $scope
            animation: 'slide-in-up'
        ).then((modal) ->
            $scope.modalFunction = modal
        )
]