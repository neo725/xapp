module.exports = ->
    card_list_name = 'card_list'

    getCardIndex = (cards, card) ->
        index = _.findIndex(cards, (currentCard) ->
            match = card.number_part1 == currentCard.number_part1
            match = match and card.number_part2 == currentCard.number_part2
            match = match and card.number_part3 == currentCard.number_part3
            match = match and card.number_part4 == currentCard.number_part4

            return match
        )

        return index

    saveDefaultCard = (card) ->
        delete card['remember']
        delete card['cvc']

        saved_card = {
            'card': card
        }
        window.localStorage.setItem 'saved_card', JSON.stringify(saved_card)

    updateStorage = (cards) ->
        i = 0
        while i < cards.length
            delete cards[i]['remember']
            delete cards[i]['cvc']
            i++
        window.localStorage.setItem card_list_name, JSON.stringify(cards)

    save = (card) ->
        cards = JSON.parse(window.localStorage.getItem(card_list_name)) || []
        index = getCardIndex(cards, card)

        if index == -1
            # addnew
            if cards.length > 0
                # update all card default = false in cards
                i = 0
                while i < cards.length
                    cards[i].default = false
                    i++
            card.default = true
            cards.push card
            updateStorage cards
            saveDefaultCard card
        else
            # update
            # update all card default = false in cards
            i = 0
            while i < cards.length
                cards[i].default = (i == index)
                if i == index
                    cards[i].expire_year = card.expire_year
                    cards[i].expire_month = card.expire_month

                    saveDefaultCard cards[i]
                i++
            updateStorage cards

    return {
        save: save
        saveCardList: updateStorage
    }