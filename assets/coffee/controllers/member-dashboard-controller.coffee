constants = require('../common/constants')

module.exports = [
    '$rootScope', '$scope', '$ionicHistory', '$ionicModal', '$cordovaAppVersion', '$cordovaCamera', '$timeout', '$jrCrop',
    'modal', 'navigation', 'api',
    ($rootScope, $scope, $ionicHistory, $ionicModal, $cordovaAppVersion, $cordovaCamera, $timeout, $jrCrop,
        modal, navigation, api) ->
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

        $scope.goPaymentList = ->
            navigation.slide 'home.member.payment-list', {}, 'left'

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
                $scope.notify = 't'
            updateSetting()

        $scope.checkNotificationIsChecked = ->
            if $scope.notify != 'f'
                $scope.notify = 't'
            return $scope.notify == 't'

        updateSetting = () ->
            data =
                'notify': 't'
            data.notify = 'f' if $scope.checkNotificationIsChecked() == false

            onSuccess = (response) ->
                console.log 'updateSetting.success'
            onError = (error, status_code) ->
                console.log 'updateSetting.error'
                console.log error
                console.log status_code

            api.postUserSetting('notify', "'#{data.notify}'", onSuccess, onError)

        $scope.takePicture = ->
            options =
                quality: 80
                destinationType: Camera.DestinationType.DATA_URL
                sourceType: Camera.PictureSourceType.CAMERA
                allowEdit: false
                encodingType: Camera.EncodingType.JPEG
                #targetWidth: 200
                #targetHeight: 200
                saveToPhotoAlbum: false
                correctOrientation: true

            $cordovaCamera.getPicture(options).then (imageData) ->
#                    $jrCrop.crop(
#                        url: 'data:image/jpeg;base64,' + imageData
#                        width: 200
#                        height: 200
#                        circle: true
#                    ).then (canvas) ->
#                        image = canvas.toDataURL()
#                        console.log image
#                    , (->)

                    #$scope.avatars = imageData
                    #$('#user-avatars').attr 'src', 'data:image/jpeg;base64,' + $scope.avatars
                    fixAvatarImage()
                    uploadAvatar = ->
                        onSuccess = (response) ->
                            #window.localStorage.setItem('avatar', imageData)
                            $scope.avatar_url = response.result
                            modal.hideLoading()
                        onError = ->
                            modal.hideLoading()
                        api.postImage('avatar', imageData, onSuccess, onError)
                    modal.showLoading('', 'message.data_saving')
                    uploadAvatar()
                , (error) ->
                    console.log error

        $scope.logout = ->
            $scope.modalFunction.hide()
            $rootScope.logout()

        retriveAvatarImageSize = ->
            $avatar = $('.avatar-img');
            width = $avatar.width()
            height = $avatar.height()

            return width * height

        $scope.$watch ->
                return retriveAvatarImageSize()
            , (value) ->
                fixAvatarImage()

        fixAvatarImage = ->
            $timeout ->
                $avatars = $('.avatar-img')
                $avatars.css('max-width', '')
                $avatars.css('max-height', '')
                width = $avatars.width()
                height = $avatars.height()
                if width < height
                    $avatars.css('max-width', '100px')
                else
                    $avatars.css('max-height', '100px')
            , 100

        loadAvatar = ->
            onSuccess = (response) ->
                if response
#                    onSuccess = (response) ->
#                        $scope.avatars = response
#                    onError = (error, status_code) ->
#                        delete $scope['avatars']
#
#                    api.getImageFromUrl response.para_value, onSuccess, onError
                    $scope.avatar_url = response.para_value
                modal.hideLoading()
            onError = (error, status_code) ->
                modal.hideLoading()

            modal.showLoading('', 'message.data_loading')
            api.getUserSetting 'avatar', onSuccess, onError

        loadData = ->
            onSuccess = (response) ->
                if (response != null)
                    $scope.notify = response.para_value
                modal.hideLoading()
                loadAvatar()

            onError = (error, status_code) ->
                console.log status_code
                console.log error
                modal.hideLoading()
                loadAvatar()

            modal.showLoading('', 'message.data_loading')
            api.getUserSetting 'notify', onSuccess, onError

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