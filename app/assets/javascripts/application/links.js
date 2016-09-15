$(function() {
  $("[role='link']").on("click", function(e) {
    window.location = e.currentTarget.dataset.link;
  });
});
