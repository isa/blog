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
