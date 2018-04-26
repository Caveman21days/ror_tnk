$ ->
  $('.add-comment-link').click (e) ->
    e.preventDefault();
    $(this).hide();
    comment_id = $(this).data('commentId')
    $('form#comment-form-' + comment_id).show();

  $('form.new_comment').bind 'ajax:success', (e) ->
    comment_block = $(this).parent()
    comment_id = comment_block.find('a.add-comment-link').data('commentId')
    comment_block.find('.comment-message').html('<p>' + e.detail[0].message + '</p>')
    $(this).hide()
    $(this).find('textarea').val('')
    comment_block.find('a.add-comment-link').show()

  $('form.new_comment').bind 'ajax:error', (e) ->
    $('.flash').append(JST['templates/errors'](e.detail[0].errors))
    comment_block = $(this).parent()
    comment_block.find('.comment-message').html('<p>' + e.detail[0].message + '</p>')
    $(this).hide()
    $(this).find('textarea').val('')
    comment_block.find('a.add-comment-link').show()


  App.cable.subscriptions.create('CommentsChannel', {
    connected: ->
      question_id = $('.question').data('questionId')
      if question_id
        @perform 'follow', question_id: question_id
      else
        @perform 'unfollow'
    ,

    received: (data) ->
      data = $.parseJSON(data)
      comment_list = $('.comments .comments-list' + '#' + data.commentable_type + '-' + data.commentable_id)
      comment_list.append(JST['templates/comments'](data.comment))
    })