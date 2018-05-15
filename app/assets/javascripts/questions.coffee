# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  questions = $('.questions')

  $('.edit-question-link').click (e) ->
    e.preventDefault();
    $(this).hide();
    question_id = $(this).data('questionId')
    console.log(question_id)
    $('form#edit-question-' + question_id).show();

  $('a.vote-question-link').bind 'ajax:success', (e) ->
    question_id = $(this).data('questionId')
    vote = e.detail[0]
    $('.vote-' + question_id).html('<p>' + vote.positive_count + ' (' + vote.positive_persent + '%) ' + ' / ' + vote.negative_count + ' (' + vote.negative_persent + '%) ' + ' | ' + vote.result + '</p>')

  $('.questions').bind 'ajax:error', (e) ->
    $('.flash').html('<p> You can not manage question </p>')


  App.cable.subscriptions.create('QuestionsChannel', {
  connected: ->
    @perform 'follow',

  received: (data) ->
    data = $.parseJSON(data)
    questions.append(JST['templates/questions'](data.question))
  })

