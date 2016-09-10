$(function() {
  $(".mobile-collapsed .expand").on("click", function(event) {
    var target = $(event.target);
    var parent = $(event.target.parentElement);

    var originalText = target.text();

    parent.toggleClass("mobile-collapsed");
    target.text(target.data("text-swap"));
    target.data("text-swap", originalText);

    return false;
  });
});
