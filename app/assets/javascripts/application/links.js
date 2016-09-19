$(function() {
  $("[role='link']").on("click", function(e) {
    window.location = e.currentTarget.getAttribute("data-link");
  });
});
