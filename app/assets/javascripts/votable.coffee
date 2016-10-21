handleRateErrors = (e, xhr) ->
  $('.alert, .notice').text('')
  responseObject = $.parseJSON(xhr.responseText)
  $.each responseObject.errors, (i, e) ->
    $('.alert').append e

handleRateSuccess = (e, data) ->
  $('.alert').text('')
  $('.notice').text(data.message)
  ratingBlock = $(e.target).parents('.rating-block')
  ratingBlock.find('.rating-value').text(data.rating)
  ratingBlock.find('.unrate-button, .rate-button').toggle()

ready = ->   
  $('.rate-button, .unrate-button')
    .bind('ajax:success', handleRateSuccess)
    .bind('ajax:error', handleRateErrors)
    
$(document).ready(ready) 
$(document).on('page:load', ready)  
$(document).on('page:update', ready)