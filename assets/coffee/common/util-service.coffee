module.exports = ['$log', ($log) ->
    checkCardType = (number) ->
        patternVisa = /^4\d{0,3}$/g
        patternMaster = /^5[1-5]\d{0,2}$/g
        #number = $scope.card.number_part1
        if patternVisa.exec(number)
            return 'visa'
        if patternMaster.exec(number)
            return 'master'
        return ''

    pad = (numeric, size, pad_string) ->
        if pad_string == undefined
            pad_string = '0'

        if numeric == undefined
            return ''

        if numeric.toString().length > size
            return numeric.toString()

        front_pad = pad_string.repeat size - 1
        str = front_pad + numeric.toString()
        return str.substr(str.length - size)

    startsWith = (string, searchString, position) ->
        position = position || 0
        return string.substr(position, searchString.length) == searchString

    getCacheMaxAge = (hour, minute, second = 0) ->
        getSeconds = (hour, minute, second) ->
            return (hour * 60 * 60 * 1000) + (minute * 60 * 1000) + (second * 1000)
        timeEnd = new Date()
        timeNow = new Date()

        day = timeNow.getDate()

        if getSeconds hour, minute < getSeconds timeNow.getHours(), timeNow.getMinutes()
            timeEnd.setDate day + 1
        timeEnd.setHours hour
        timeEnd.setMinutes minute
        timeEnd.setSeconds second

        return timeEnd.getTime() - timeNow.getTime()

    return {
        checkCardType: checkCardType
        pad: pad
        startsWith: startsWith
        getCacheMaxAge: getCacheMaxAge
    }
]