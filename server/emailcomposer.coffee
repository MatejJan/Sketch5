class @EmailComposer
  constructor: ->
    @text = ""
    @html = "<!DOCTYPE html><html><body>"

  addParagraph: (text) ->

    formattedText = @_formatText text
    @text += "#{formattedText}\n\n"

    html = @_transformTextToHtml text
    @html += "<p>#{html}</p>\n"

  addImage: (imageContentId) ->
    # Only html supports inline images.
    @html += "<p><img src=\"cid:#{imageContentId}\" /></p>"

  end: ->
    @html += "</body></html>"

  _formatText: (text) ->
    lines = text.split '\n'

    # Wrap lines at 40 characters.
    formattedLines = for line in lines
      words = line.split ' '

      formattedLine = ""
      currentLine = ""

      appendCurrentLine = ->
        formattedLine += "\n" if formattedLine.length
        formattedLine += currentLine

      # Repeat until we run out of words.
      while words.length
        nextWord = words.shift()

        # Always add the first word.
        unless currentLine.length
          currentLine = nextWord
          continue

        # Check if adding to current line would go over 40 characters.
        if currentLine.length + nextWord.length + 1 > 40
          # We need a new line.
          appendCurrentLine()
          currentLine = nextWord

        else
          currentLine += " " + nextWord

      # Add the final line.
      appendCurrentLine()
      formattedLine

    formattedLines.join '\n'

  _transformTextToHtml: (text) ->
    # Create line breaks.
    formattedText = text.replace /\n/g, '<br/>'

    # Create links.
    urlRegex = /(https?):\/\/([\w_-]+(?:(?:\.[\w_-]+)+))([\w.,@?^=%&:\/~+#-]*[\w@?^=%&\/~+#-])?/g

    formattedText = formattedText.replace urlRegex, (url, protocol, domain, path) =>
      "<a href='#{url}' target='_blank'>#{protocol}://#{domain}</a>"

    formattedText
