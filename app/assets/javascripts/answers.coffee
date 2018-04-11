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