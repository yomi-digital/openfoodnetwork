$ ->
  if $('form#update-cart').is('*') || $('form#update-order').is('*')
    $('form#update-cart a.delete, form#update-order a.delete').show().one 'click', ->
      $(this).parents('.line-item').first().find('input.line_item_quantity').val 0
      $(this).parents('form').first().submit()
      false

  ($ 'form#update-cart').submit ->
    ($ 'form#update-cart #update-button').attr('disabled', true)

  ###
  This piece of code checks for the status of 
  Address to be procured from this API: https://github.com/yomi-digital/ficosofn/issues/4
  @YOMI_TODO move the URI to a static variable
  ###
  if $('#crypto-payment-timer').length
    $.get 'http://134.209.31.112:4000/payments/check/', (data) ->
      $('#crypto-payment-timer span').text(data['message']['payment']['status'])