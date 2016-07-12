$(function() {
  $(".toggle").on("click", function(event) {
    var trigger = $(event.target);

    var target = trigger.data("toggle-target");
    $(target).toggleClass("collapsed")

    var originalText = trigger.text();
    trigger.text(trigger.data("toggle-text"));
    trigger.data("toggle-text", originalText);

    return false;
  });
});
