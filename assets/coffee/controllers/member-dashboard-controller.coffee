constants = require('../common/constants')

module.exports = [
    '$rootScope', '$scope', '$ionicHistory', '$ionicModal', '$cordovaAppVersion', '$cordovaCamera', '$timeout', '$jrCrop', '$log',
    '$ionicActionSheet', '$ionicPopover', '$translate',
    'modal', 'navigation', 'api', 'user',
    ($rootScope, $scope, $ionicHistory, $ionicModal, $cordovaAppVersion, $cordovaCamera, $timeout, $jrCrop, $log,
        $ionicActionSheet, $ionicPopover, $translate,
        modal, navigation, api, user) ->
            $scope.gender_title = ''
            $scope.data_loaded = false
            $scope.notify = constants.DEFAULT_NOTIFICATION_SETTING
            $scope.active = false
            $scope.is_guest = user.getIsGuest()
            $scope.canRefresher = not $scope.is_guest

            $scope.goBack = ->
                if not $scope.active
                    return

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
                if $rootScope.notify == 't'
                    $rootScope.notify = 'f'
                else
                    $rootScope.notify = 't'
                updateSetting()

            $scope.checkNotificationIsChecked = ->
                if $rootScope.notify != 'f'
                    $rootScope.notify = 't'
                return $rootScope.notify == 't'

            updateSetting = () ->
                data =
                    'notify': 't'
                data.notify = 'f' if $scope.checkNotificationIsChecked() == false

                onSuccess = (->)
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
                    $log.error error

            $scope.takePicture = ->
                getCamera(Camera.PictureSourceType.CAMERA)

            $scope.choicePicture = ->
                getCamera(Camera.PictureSourceType.PHOTOLIBRARY)

            $scope.deleteAvatar = ->
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
                #$scope.modalFunction.show()
                hideSheet = $ionicActionSheet.show(
                    buttons: [
                        { text: '<i class="icon ion-camera"></i> 拍攝照片' }
                        { text: '<i class="icon ion-images"></i> 選擇照片' }
                        { text: '<i class="icon ion-android-delete"></i> 刪除' }
                    ]
                    buttonClicked: (buttonIndex) ->
                        switch buttonIndex
                            when 0 then $scope.takePicture()
                            when 1 then $scope.choicePicture()
                            when 2 then $scope.deleteAvatar()
                        hideSheet()
                )

            $scope.doRefresh = () ->
                #$scope.$broadcast('scroll.refreshComplete')
                loadData()

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
                        $rootScope.avatar_url = response.para_value
                    modal.hideLoading()
                onError = () ->
                    modal.hideLoading()

                modal.showLoading('', 'message.data_loading')
                api.getUserSetting 'avatar', onSuccess, onError

            loadData = ->
                onSuccess = (response) ->
                    if (response != null)
                        $rootScope.notify = response.para_value
                    modal.hideLoading()
                    loadAvatar()
                    $scope.data_loaded = true

                onError = () ->
                    modal.hideLoading()
                    loadAvatar()

                modal.showLoading('', 'message.data_loading')
                api.getUserSetting 'notify', onSuccess, onError

            if $rootScope.notify
                $scope.data_loaded = true

            if $scope.is_guest
                $translate(['text.guest_name']).then (translator) ->
                    $scope.member =
                        memb_name: translator['text.guest_name']
            else
                if $scope.data_loaded == false
                    loadData()
                else if not $rootScope.avatar_url
                    loadAvatar()

            initPopoverUnlogin = ->
                if $scope.popoverUnlogin
                    $q.when
                else
                    $ionicPopover.fromTemplateUrl('templates/popover-unlogin.html',
                        scope: $scope
                        backdropClickToClose: false
                        hardwareBackButtonClose: false
                    ).then((popover) ->
                        $scope.popoverUnlogin = popover
                    )

            showUnlogin = ->
                initPopoverUnlogin().then ->
                    $scope.popoverUnlogin.show('.function-list')
                    $scope.currentShowDialog =
                        el: $scope.popoverUnlogin
                        'tag': 'popoverUnlogin'

            #showUnlogin()

            removeCurrentShowDialog = ->
                $scope.currentShowDialog.el.remove()
                delete $scope[$scope.currentShowDialog.tag]
            $scope.$on('popover.hidden', removeCurrentShowDialog)

            $scope.$on('$ionicView.afterEnter', ->
                $timeout ->
                    $scope.active = true
                , 1000
            )
            $scope.$on('$ionicView.leave', ->
                $scope.active = false

                if $scope.popoverUnlogin
                    $timeout(->
                        $scope.popoverUnlogin.hide()
                    )
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