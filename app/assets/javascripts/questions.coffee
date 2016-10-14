ready = ->   
  $(document).on 'click', '.edit-question-link', (e) ->
    e.preventDefault()
    $(this).hide()  
    $('.edit_question').show()

$(document).ready(ready) 
$(document).on('page:load', ready)  
$(document).on('page:update', ready)