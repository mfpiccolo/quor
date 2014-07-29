ready = ->
  $(".pagination").hide()
  $("#models .page").infinitescroll
    navSelector: "nav.pagination" # selector for the paged navigation (it will be hidden)
    nextSelector: "nav.pagination a[rel=next]" # selector for the NEXT link (to page 2)
    itemSelector: "#models tr.model" # selector for all items you'll retrieve
    animate: true
  , (arrayOfNewElems) ->
    $(this).children().children().each () ->
      $(this).children().html("-") unless $(this).children().text().length

$(document).ready(ready);

$(document).on('page:load', ready);
