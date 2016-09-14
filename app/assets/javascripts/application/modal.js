$(function() {
  $(".modal-open").on("click", function(e) {
    var modal = $("#" + e.target.dataset.modalTarget);
    modal.addClass("active");

    var close = function() { this.removeClass("active"); };

    modal.on("click", close.bind(modal));
    modal.find(".modal-close").on("click", close.bind(modal));
    modal.find(".modal-foreground").on("click", function() { return false; });
  });
});
