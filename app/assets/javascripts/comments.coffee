ready = ->   
  App.cable.subscriptions.create('CommentsChannel', {
    connected: ->
      @perform 'follow'
    received: (data) ->
      commentableType = data.comment.commentable_type.toLowerCase()
      commentableId = data.comment.commentable_id
      commentsBlock = $('.' + commentableType + ' .comments-' + commentableId)
      if(commentsBlock.length > 0)
        commentsBlock.append(App.helper.render('comments/comment', data.comment))      
  })

$(document).ready(ready) 
$(document).on('page:load', ready)  
$(document).on('page:update', ready)