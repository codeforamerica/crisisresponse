$(function() {
  $("[role='link']").on("click", function(e) {
    if(e.target.tagName !== "A") {
      window.location = e.currentTarget.getAttribute("data-link");
    }
  });
});
