Number::format = ->
  if this == 0
    return 0
  reg = /(^[+-]?\d+)(\d{3})/
  n = this + ''
  while reg.test(n)
    n = n.replace(reg, '$1' + ',' + '$2')
  n

String::format = ->
  num = parseFloat(this)
  if isNaN(num)
    return '0'
  num.format()

$(document).ready ->
  $.ajax 'profile/incomedata',
    type: 'GET'
    dataType: 'text'
    error: (request, status, errorThrown) ->
        console.log("error: #{status}")
    success: (data, status, reuqest) ->
      data = $.parseJSON(data)
      income = Number(data["income"].toString())
      expense = Number(data["expense"].toString())

      $("span.income").text(income.format())
      $("span.expense").text(expense.format())
