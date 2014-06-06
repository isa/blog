# DocPad Configuration File
# http://docpad.org/docs/config

# Define the DocPad Configuration
docpadConfig = {
   templateData:
      site:
         url: "http://isagoksu.com"
         title: "Simple and Pragmatic Thoughts"
         author: "Isa Goksu"
         email: "info@isagoksu.com"
         timestamp: new Date().getTime()

      getTwitterLink: (document) ->
         "https://twitter.com/home?status=" + encodeURIComponent(document.title + " by @IsaGoksu: http://isa.io" + document.url)

      getFacebookLink: (document) ->
         "https://www.facebook.com/sharer/sharer.php?u=" + encodeURIComponent('http://isa.io' + document.url)

   plugins:
      cleanurls:
         static: true
         trailingSlashes: true
      highlightjs:
         replaceTab: 3
      related:
         parentCollectionName: 'posts'

   collections:
      posts: ->
         @getCollection("html").findAllLive({isPost: true})
}

# Export the DocPad Configuration
module.exports = docpadConfig
