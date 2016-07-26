{shell} = require 'electron'

describe "uriopener package", ->
  beforeEach ->
    waitsForPromise ->
      atom.packages.activatePackage('language-gfm')

    waitsForPromise ->
      atom.packages.activatePackage('language-javascript')

    waitsForPromise ->
      atom.packages.activatePackage('language-hyperlink')

    waitsForPromise ->
      activationPromise = atom.packages.activatePackage('uriopener')
      atom.commands.dispatch(atom.views.getView(atom.workspace), 'uriopener:open')
      activationPromise

  describe "when the cursor is on a link", ->
    it "opens the link using the 'open' command", ->
      waitsForPromise ->
        atom.workspace.open('sample.js')

      runs ->
        editor = atom.workspace.getActiveTextEditor()
        editor.setText("// \"http://github.com\"")

        spyOn(shell, 'openExternal')
        atom.commands.dispatch(atom.views.getView(editor), 'uriopener:open')
        expect(shell.openExternal).not.toHaveBeenCalled()

        editor.setCursorBufferPosition([0, 4])
        atom.commands.dispatch(atom.views.getView(editor), 'uriopener:open')

        expect(shell.openExternal).toHaveBeenCalled()
        expect(shell.openExternal.argsForCall[0][0]).toBe 'http://github.com'

        shell.openExternal.reset()
        editor.setCursorBufferPosition([0, 8])
        atom.commands.dispatch(atom.views.getView(editor), 'uriopener:open')

        expect(shell.openExternal).toHaveBeenCalled()
        expect(shell.openExternal.argsForCall[0][0]).toBe 'http://github.com'

        shell.openExternal.reset()
        editor.setCursorBufferPosition([0, 21])
        atom.commands.dispatch(atom.views.getView(editor), 'uriopener:open')

        expect(shell.openExternal).toHaveBeenCalled()
        expect(shell.openExternal.argsForCall[0][0]).toBe 'http://github.com'
