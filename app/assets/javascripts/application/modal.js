$(function() {
  $(".modal-open").on("click", function(e) {
    e.stopPropagation();

    var targetSelector = e.target.getAttribute("data-modal-target");
    var modal = $(targetSelector);
    modal.addClass("active");

    var close = function(e) {
      e.stopPropagation();
      this.removeClass("active");
    };

    modal.on("click", close.bind(modal));
    modal.find(".modal-close").on("click", close.bind(modal));
    modal.find(".modal-foreground").on("click", function() { return false; });

    return false;
  });
});
