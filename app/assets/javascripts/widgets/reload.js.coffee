class ReloadWidget extends BaseWidget
  init: ->
    window.setTimeout ->
      window.location.reload()
    , @options.ms

Widgets.register 'reload', ReloadWidget
