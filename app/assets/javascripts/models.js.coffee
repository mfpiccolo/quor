ready = ->
  $("#models .page").infinitescroll
    navSelector: ".pagination" # selector for the paged navigation (it will be hidden)
    nextSelector: "nav.pagination a[rel=next]" # selector for the NEXT link (to page 2)
    itemSelector: "#models tr.model" # selector for all items you'll retrieve
    animate: false
  , (arrayOfNewElems) ->
    $(this).children().children().each () ->
      $(this).children().html("-") unless $(this).children().text().length
  $(".best_in_place").best_in_place();

$(document).ready(ready);

$(document).on('page:load', ready);
