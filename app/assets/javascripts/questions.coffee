ready = ->   
  questionsList = $('.questions-list')

  $(document).on 'click', '.edit-question-link', (e) ->
    e.preventDefault()
    $(this).hide()  
    $('.edit_question').show()

  App.cable.subscriptions.create('QuestionsChannel', {
    connected: ->
      @perform 'follow' 
    received: (data) ->
      questionsList.append(data)
  })

$(document).ready(ready) 
$(document).on('page:load', ready)  
$(document).on('page:update', ready)