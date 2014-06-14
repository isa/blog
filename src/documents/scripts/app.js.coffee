$(document).ready () ->
   padding = 99
   $('#toc').html($("h3").clone())
   headers = $('#toc h3')
   headers.each () ->
      $(this).hide()

   displayHeader = (index) ->
      $(headers[index]).fadeIn('slow')
      hideRest(index)

   hideRest = (index) ->
      $(headers).each (idx) ->
         $(this).hide() unless idx == index

   $(window).scroll(() ->
      displayIndex = -1
      scrollTop = $(window).scrollTop()

      footNote = $('ol:last')
      if (scrollTop + padding > footNote.offset().top)
         hideRest(-1)
      else
         $('.article h3').each (index) ->
            offset = $(this).offset()

            if (scrollTop + padding > offset.top + $(this).height())
               displayIndex = index

         if displayIndex > -1
            displayHeader(displayIndex)
         else
            hideRest(-1)
   ).trigger "scroll"
