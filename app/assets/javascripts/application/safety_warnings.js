$(function() {
  $(".safety_warning-fields .nested-fields").each(function(_, element) {
    updateForm(element);
  });

  $(".response_plan_safety_warnings_category input").on("click", function(event) {
    var form = $(event.target).closest(".nested-fields");
    updateForm(form, event.target.value);
  });

  function updateForm(form, value) {
    form = $(form);
    var category_radios = form.find(".response_plan_safety_warnings_category");
    var physical_threat_node = form.find(".response_plan_safety_warnings_physical_or_threat");

    if (value == undefined) {
      value = category_radios.find("input[checked]")[0].value;
    }

    debugger;

    if (value.indexOf("assault") == -1) {
      physical_threat_node.addClass("hidden");
      physical_threat_node.find("input").attr("checked", false)
    } else {
      physical_threat_node.removeClass("hidden");
    }
  };
});
