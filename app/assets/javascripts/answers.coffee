# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/



$ ->
  $('.edit-answer-link').click (e) ->
    e.preventDefault();
    $(this).hide();
    answer_id = $(this).data('answerId')
    $('form#edit-answer-' + answer_id).show();

  $('a.vote-answer-link').bind 'ajax:success', (e) ->
    answer_id = $(this).data('answerId')
    vote = e.detail[0]
    $('.vote-' + answer_id).html('<p>' + vote.positive_count + ' (' + vote.positive_persent + '%) ' + ' / ' + vote.negative_count + ' (' + vote.negative_persent + '%) ' + ' | ' + vote.result + '</p>')

  $('.answers a').bind 'ajax:error', (e) ->
    $('.flash').html('<p> You can not manage answer </p>')


  App.cable.subscriptions.create('AnswersChannel', {
    connected: ->
      question_id = $('.question').data('questionId')
      if question_id
        @perform 'follow', question_id: question_id
      else
        @perform 'unfollow'
    ,

    received: (data) ->
      data = $.parseJSON(data)
      console.log data.attachments
      if data.answer.user_id != gon.user_id
        $('.answers').append(JST["templates/answers"](data))
  })
