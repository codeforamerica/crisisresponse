$(function() {
  window.mask_date_fields = function(){
    var date_of_birth_fields = $('input[placeholder="mm-dd-yyyy"]');

    date_of_birth_fields.
      mask("99-99-9999", {
        placeholder: "__-__-____",
        autoclear: false
      });
  }
});

$(window.mask_date_fields);
