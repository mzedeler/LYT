# Requires `/common`
# Requires `dtbdocument`

# -------------------

# This class models a Daisy Text Content document (an XHTML file
# containing the text of a book)

class LYT.TextContentDocument extends LYT.DTBDocument

  # Private method for resolving URLs
  resolveURLs = (source, resources) ->

    # Resolve images
    source.find("*[src]").each (index, item) ->
      item = jQuery item
      return if item.data("resolved")?
      url = item.attr("src").split("/").pop()
      item.attr "src", resources[url]?.url
      item.data "resolved", "yes" # Mark as processed

    ###
    # Resolve stylesheets
    source.find("link[href]").each (index, item) ->
      item = jQuery item
      url = item.attr("href").split("/").pop()
      item.attr("href", resources[url]?.url)
    ###

  stripTags = (source) ->
    source.remove("link").remove("script")

  constructor: (url, resources, callback) ->
    super url, =>
      resolveURLs @source, resources
      stripTags @source
      callback() if typeof callback is "function"

  hideImages: (altSrc) ->
    @source.find("img[src]").each ->
      el = jQuery this
      return if el.attr "data-src"

      el.attr "data-src", el.attr "src"
      el.removeAttr "src"
      el.attr "src", altSrc if altSrc
