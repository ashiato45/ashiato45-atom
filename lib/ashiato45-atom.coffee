Ashiato45AtomView = require './ashiato45-atom-view'
{CompositeDisposable} = require 'atom'
{BufferedProcess} = require 'atom'
FS = require "fs"

module.exports = Ashiato45Atom =
  ashiato45AtomView: null
  modalPanel: null
  subscriptions: null

  activate: (state) ->
    @ashiato45AtomView = new Ashiato45AtomView(state.ashiato45AtomViewState)
    @modalPanel = atom.workspace.addModalPanel(item: @ashiato45AtomView.getElement(), visible: false)

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'ashiato45-atom:callnkf': => @callnkf()
    @subscriptions.add atom.commands.add 'atom-workspace', 'ashiato45-atom:alerttest': => @alerttest()
    @subscriptions.add atom.commands.add 'atom-workspace', 'ashiato45-atom:makepng': => @makepng()
    # @subscriptions.add atom.commands.add 'atom-workspace', 'ashiato45-atom:forwardsearch': => @forwardsearch()


  deactivate: ->
    @modalPanel.destroy()
    @subscriptions.dispose()
    @ashiato45AtomView.destroy()

  serialize: ->
    ashiato45AtomViewState: @ashiato45AtomView.serialize()

  callnkf: ->
    console.log 'Ashiato45Atom-callnkf'

    command = 'nkf'
    editor = atom.workspace.getActiveEditor()
    filename = editor.getPath()
    args = ["-w8", "--overwrite", filename]
    stdout = (output) ->
      alert "Executed 'nkf -w8 --overwrite #{filename}'"
    exit = (code) ->
    process = new BufferedProcess({command, args, stdout, exit})

    #if @modalPanel.isVisible()
    #  @modalPanel.hide()
    #else
    #  @modalPanel.show()

  alerttest: ->
    fs = require 'fs'
    alert __dirname

  makepng: ->
    path = require('path')
    editor = atom.workspace.getActiveTextEditor()
    dirname = path.dirname editor.getPath()
    date = new Date()
    filename = date.getTime().toString() + ".png"
    filepath = path.join(dirname, "images", filename)
    imgpath = path.join(dirname, "images")
    alert filepath
    blank = path.join(__dirname, "blank.png")

    fs = require('fs')
    if fs.existsSync(imgpath) is false
      alert "/images not found!"
      return

    read = FS.createReadStream(blank, {bufferSize: 32})
    write = FS.createWriteStream(filepath)
    read.on("error", (e) ->
      alert e.toString())
    write.on("error", (e) ->
      alert e.toString())
    read.pipe(write)

    command = 'mspaint'
    args = [filepath]
    stdout = (output) ->
      alert "Executed 'mspaint #{filepath}'"
    exit = (code) ->
    process = new BufferedProcess({command, args, stdout, exit})
    editor.insertText(filename)

  forwardsearch: ->
    command = path.join(__dirname, 'calldde.exe');
    editor = atom.workspace.getActiveEditor();
    filename = editor.getPath()
    args = [filename, (editor.cursors[0].getBufferRow() + 1).toString()]
    stdout = (output) ->
    exit = (code) ->
    process = new BufferedProcess({command, args, stdout, exit})
