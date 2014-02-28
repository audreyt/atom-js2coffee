js2coffee = require('./js2coffee');
coffee2ls = require('./coffee2ls.js');

RangeFinder = require './range-finder'

module.exports =
  activate: ->
    atom.workspaceView.command 'js2ls:toggle', '.editor', =>
      editor = atom.workspaceView.getActivePaneItem()
      @convert(editor)

  convert: (editor) ->
    ranges = RangeFinder.rangesFor(editor)
    ranges.forEach (range) =>
      jsContent = editor.getTextInBufferRange(range)
      try
        coffeeContent = js2coffee.build(jsContent, {indent: editor.getTabText()});
        lsContent = coffee2ls.compile coffee2ls.parse coffeeContent
        editor.setTextInBufferRange(range, lsContent)
      catch e
        console.error("invalid javascript")
