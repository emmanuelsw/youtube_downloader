App.downloader = App.cable.subscriptions.create "DownloaderChannel",
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    console.log data
    if data.status == "finished"
      $('#download-form button').addClass 'hidden'
      $('#download-form a').removeClass 'hidden'
      $('#download-form a').attr href: data.url

