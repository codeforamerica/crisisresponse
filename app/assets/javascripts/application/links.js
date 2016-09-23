$(function() {
  $("[role='link']").on("click", function(e) {
    if(e.target.tagName !== "A") {
      var destination = e.currentTarget.getAttribute("data-link");

      if(destination) {
        window.location = destination;
      }
    }
  });
});
