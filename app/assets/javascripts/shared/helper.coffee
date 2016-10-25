App = window.App || {}

App.helper = 
  render: (template, data) ->
    JST["templates/#{template}"](data)
