module.exports = [
    '$rootScope', '$scope', '$translate', '$ionicSlideBoxDelegate', 'modal', 'plugins', 'api',
    ($rootScope, $scope, $translate, $ionicSlideBoxDelegate, modal, plugins, api) ->

        resetStar = ->
            $scope.rating = []
            i = 0
            max = 10
            while i < max
                $scope.rating[i] = 0
                i++

        $rootScope.resetStarFunction = ->
            resetStar()

        $scope.rateFunction = (index, rating) ->
            $scope.rating[index] = rating

            console.log $scope.rating

        $scope.closeSurvey = ->
            $scope.modalFeedback.hide()

        $scope.submitFeedback = () ->
#            console.log $scope.currentCard
#            console.log $rootScope.topics
#            console.log $scope.rating
            modal.showLoading('', 'message.data_loading')

            topics = []
            i = 0
            max = $rootScope.topics.length
            while i < max
                topics.push {
                    'topic_no': $rootScope.topics[i].Topic_No
                    'answer_value': $scope.rating[i]
                }
                i++
            data = {
                'class_id': $scope.currentCard.Prod_Id
                'answer': topics
            }

            onSuccess = ->
                modal.hideLoading()
                index = _($rootScope.studyCards).findIndex({ 'Prod_Id': $scope.currentCard.Prod_Id })
                if index > -1
                    $rootScope.studyCards.splice(index, 1)

                if $rootScope.studyCards.length > 0
                    newIndex = index - 1
                    if newIndex == -1
                        newIndex = 0
                    $ionicSlideBoxDelegate.slide(index - 1)
                $ionicSlideBoxDelegate.update()

                $scope.modalFeedback.hide()
            onError = ->
                modal.hideLoading()
                $translate('errors.request_failed').then (text) ->
                    plugins.toast.show(text, 'long', 'top')
                $scope.modalFeedback.hide()

            api.postSurveyFill(data, onSuccess, onError)
]