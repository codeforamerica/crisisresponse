$(function(){
  var date_of_birth_fields = $(
    "#search_date_of_birth, #response_plan_person_attributes_date_of_birth"
  );

  date_of_birth_fields.
     mask("99-99-9999", {
     placeholder: "__-__-____",
     autoclear: false
   });
});
