$(document).ready ->
  $.ajax 'profile/incomedata',
    type: 'GET'
    dataType: 'text'
    error: (request, status, errorThrown) ->
        console.log("error: #{status}")
    success: (data, status, reuqest) ->
      data = $.parseJSON(data)
      $("span.income").text(data["income"])
      $("span.expense").text(data["expense"])
