handleEditLinkClick = (e) ->
  e.preventDefault()
  $(this).hide()
  answer_id = $(this).data('answerId')
  $('form#edit-answer-' + answer_id).show()

ready = ->
  $(document).on('click', '.edit-answer-link', handleEditLinkClick)    

  gon.question && App.cable.subscriptions.create('AnswersChannel', {
    connected: ->
      @perform 'follow', question_id: gon.question.id
    received: (data) -> 
      $('.answers').append(App.helper.render('answers/answer', data.answer))
  })

$(document).ready(ready) 
$(document).on('page:load', ready)  
$(document).on('page:update', ready)