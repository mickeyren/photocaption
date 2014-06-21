class PhotoCaption.Photo
  init: ->
    @addresses = SmartThings.extend(@addresses, SmartThings.Address)
    @credit_cards = SmartThings.extend(@credit_cards, SmartThings.CreditCard)

  hasAddress: (address) ->
    @addresses.filter((existing) -> existing.id == address.id).length > 0
