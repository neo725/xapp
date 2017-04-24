module.exports = [
    '$rootScope', '$scope', '$translate', '$ionicHistory', '$log', '$timeout',
    'navigation', 'modal', 'api', 'plugins', 'util', 'user',
    ($rootScope, $scope, $translate, $ionicHistory, $log, $timeout,
        navigation, modal, api, plugins, util, user) ->

            $scope.input_data =
                verify_code = ''

            $scope.goBack = () ->
                backView = $ionicHistory.backView()

                if backView
                    if backView.stateName == 'home.member.edit-email'
                        navigation.slide 'home.member.edit', {}, 'right'
                    else
                        navigation.slide 'home.member.dashboard', {}, 'right'
                else
                    navigation.slide('home.member.dashboard', {}, 'right')

            if $rootScope.member
                if $rootScope.member.from == 'edit-email'
                    $scope.email = $rootScope.member.new_memb_email
                    #getExpireCountdown()
                    return
                navigation.slide 'home.member.dashboard', {}, 'right'
]