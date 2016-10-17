$(function() {
  $(".toggle").on("click", function(event) {
    var trigger = $(event.currentTarget);

    var target = trigger.data("toggle-target");
    $(target).toggleClass("collapsed")

    if (trigger.data("toggle-text")) {
      var originalText = trigger.text();
      trigger.text(trigger.data("toggle-text"));
      trigger.data("toggle-text", originalText);
    }

    return false;
  });
});
