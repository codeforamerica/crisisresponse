$(document).keypress(function(e) {
  // Ctrl-G: Change between day and night themes
  if(e.charCode === 7 && e.ctrlKey === true) {
    $(".change-theme").trigger("click");
  }
});
