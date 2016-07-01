$(function() {
  $("#js-toggle-menu").on("click", function() {
    $("body").toggleClass("menu-active");
  });

  $(".change-theme").on("click", function() {
    $.post("/preferences");

    var stylesheet = $(".theme-stylesheet");
    var originalLink = stylesheet.attr("href");

    stylesheet.attr("href", stylesheet.data("alternate"));
    stylesheet.data("alternate", originalLink);

    return false;
  });
});
