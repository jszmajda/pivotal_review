$ ->
  pid = $('table').data('project-id')
  $('.ratings a').each (i,e) ->
    $(e).click ->
      $.ajax({
        url: '/projects/'+pid+'/rate'
        data: {
          rating: $(e).data('size')
          story: $(e).parents('tr').data('story-id')
        }
        success: (d) ->
          outer = $($(e).parents('.ratings').parent())
          outer.append($(e).remove())
          outer.find('.ratings').remove()
        error: (d) ->
          alert('whoops, error. Try again')
      })
