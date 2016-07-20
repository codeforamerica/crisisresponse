$(function() {
  var focusedImageClass = "image-thumbnail-focused"

  $(".image-scroll-arrow").on("click", function(event) {
    var focusedIndex = $("." + focusedImageClass).index();
    var direction = event.target.getAttribute("data-direction");
    var numImages = $(".image-thumbnail").length;

    if(direction == "next")
      focusedIndex = changeIndexBy(focusedIndex, 1, numImages);
    else if(direction == "prev")
      focusedIndex = changeIndexBy(focusedIndex, -1, numImages);

    focusOnImage(focusedIndex);
  });

  $(".image-thumbnail").on("click", function(event) {
    var clickedIndex = $(event.target).index();
    focusOnImage(clickedIndex);
  });

  function changeIndexBy(index, delta, numImages) {
    var newIndex = index + delta;
    while(newIndex >= numImages) { newIndex -= numImages; }
    while(newIndex < 0) { newIndex += numImages; }
    return newIndex;
  }

  function focusOnImage(index) {
    $("." + focusedImageClass).removeClass(focusedImageClass)

    var image = $(".image-thumbnail")[index];
    image.className += " " + focusedImageClass;

    $(".focused-image").attr("src", $(image).attr("src"));
  }
});
