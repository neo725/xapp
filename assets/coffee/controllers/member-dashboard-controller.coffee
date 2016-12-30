constants = require('../common/constants')

module.exports = [
    '$rootScope', '$scope', '$ionicHistory', '$ionicModal', '$cordovaAppVersion', '$cordovaCamera', '$timeout', '$jrCrop',
    'modal', 'navigation', 'api',
    ($rootScope, $scope, $ionicHistory, $ionicModal, $cordovaAppVersion, $cordovaCamera, $timeout, $jrCrop,
        modal, navigation, api) ->
        #$scope.user = {}
        $scope.gender_title = ''
        $scope.data_loaded = false
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
            navigation.slide 'home.member.edit', {}, 'left'

        $scope.goSuggest = ->
            navigation.slide 'home.member.suggestion', {}, 'left'

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
            onError = (->)

            api.postUserSetting('notify', "'#{data.notify}'", onSuccess, onError)

        getCamera = (pictureSourceType) ->
            options =
                quality: 80
                destinationType: Camera.DestinationType.DATA_URL
                sourceType: pictureSourceType
                allowEdit: false
                encodingType: Camera.EncodingType.JPEG
                targetWidth: 1000
                targetHeight: 1000
                saveToPhotoAlbum: false
                correctOrientation: true

            $cordovaCamera.getPicture(options).then (imageData) ->
                fixAvatarImage()

                uploadAvatar = ->
                    onSuccess = (response) ->
                        $scope.avatar_url = response.result
                        modal.hideLoading()
                    onError = () ->
                        modal.hideLoading()

                    api.postImage('avatar', imageData, onSuccess, onError)

                $jrCrop.crop(
                    url: 'data:image/jpeg;base64,' + imageData
                    width: 200
                    height: 200
                    circle: true
                ).then (canvas) ->
                        imageData = canvas.toDataURL()
                        pos = imageData.indexOf(',')
                        if pos > -1
                            imageData = imageData.substr(pos + 1)

                        modal.showLoading('', 'message.data_saving')
                        uploadAvatar()
                    , (->)
            , (error) ->
                console.log error

        $scope.takePicture = ->
            $scope.modalFunction.hide()
            getCamera(Camera.PictureSourceType.CAMERA)

        $scope.choicePicture = ->
            $scope.modalFunction.hide()
            getCamera(Camera.PictureSourceType.PHOTOLIBRARY)

        $scope.deleteAvatar = ->
            $scope.modalFunction.hide()

            onSuccess = () ->
                modal.hideLoading()
                delete $scope['avatar_url']
            onError = () ->
                modal.hideLoading()

            modal.showLoading('', 'message.data_updating')
            api.deleteUserSetting 'avatar', onSuccess, onError

        $scope.getGenderTitle = (gender) ->
            value = ''
            switch gender
                when 'M' or 'm' then value = '先生'
                when 'F' or 'f' then value = '小姐'

            return value

        $scope.showFunction = () ->
            $scope.modalFunction.show()

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
                    $scope.avatar_url = response.para_value
                modal.hideLoading()
            onError = () ->
                modal.hideLoading()

            modal.showLoading('', 'message.data_loading')
            api.getUserSetting 'avatar', onSuccess, onError

        loadData = ->
            onSuccess = (response) ->
                if (response != null)
                    $scope.notify = response.para_value
                modal.hideLoading()
                loadAvatar()
                $scope.data_loaded = true

            onError = () ->
                modal.hideLoading()
                loadAvatar()

            modal.showLoading('', 'message.data_loading')
            api.getUserSetting 'notify', onSuccess, onError

        #$scope.$on('$ionicView.enter', ->
        if $scope.data_loaded == false
            loadData()
        #)

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