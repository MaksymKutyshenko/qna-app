handleRateErrors = (e, xhr) ->
  $('.alert, .notice').text('')
  responseObject = $.parseJSON(xhr.responseText)
  $.each responseObject.errors, (i, e) ->
    $('.alert').append e

handleRateSuccess = (e, data) ->
  $('.alert').text('')
  $('.notice').text(data.message)
  $('.subscribe-button, .unsubscribe-button').toggle()

ready = ->
  $('.subscribe-button, .unsubscribe-button')
    .bind('ajax:success', handleRateSuccess)
    .bind('ajax:error', handleRateErrors)

$(document).ready(ready)
$(document).on('page:load', ready)
$(document).on('page:update', ready)
