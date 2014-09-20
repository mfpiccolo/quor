ready = ->
  $(".add-mapping").on "click", "#add-mapping", (event) ->
    event.preventDefault
    event.stopPropagation

    $.ajax
      url: "/admin/producer/imports/add_mappings"
      type: "GET"
      # done: submissionSucceeded
      # fail: submissionFailed
      data: {
        step: {sequence_id: seq_id},
        work_order_id: wo_id
      }
