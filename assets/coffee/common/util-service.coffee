module.exports = ->
    checkCardType = (number) ->
        patternVisa = /^4\d{0,3}$/g
        patternMaster = /^5[1-5]\d{0,2}$/g
        #number = $scope.card.number_part1
        if patternVisa.exec(number)
            return 'visa'
        if patternMaster.exec(number)
            return 'master'
        return ''

    pad = (numeric, size) ->
        if numeric.toString().length > size
            return numeric.toString()

        zero = '0'.repeat size - 1
        str = zero + numeric.toString()
        return str.substr(str.length - size)

    return {
        checkCardType: checkCardType
        pad: pad
    }