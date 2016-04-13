class ResponsePlanBuilder
  PLACEHOLDER = "REPLACE ME"
  PLACEHOLDER_IMAGE = "https://randomuser.me/api/portraits/med/men/43.jpg"

  def self.build(data)
    data = data.to_h

    preparer = {
      name: PLACEHOLDER,
      phone: PLACEHOLDER,
      team: PLACEHOLDER,
    }

    contacts = [
      {
        name: PLACEHOLDER,
        relationship: PLACEHOLDER,
        phone: PLACEHOLDER,
        notes: PLACEHOLDER,
      },
      {
        name: PLACEHOLDER,
        relationship: PLACEHOLDER,
        phone: PLACEHOLDER,
        notes: PLACEHOLDER,
      },
    ]

    ResponsePlan.new(
      city_state_zip: PLACEHOLDER,
      contacts: contacts,
      image: PLACEHOLDER_IMAGE,
      license_number: PLACEHOLDER,
      license_state: PLACEHOLDER,
      preparer: preparer,
      safety_notes: PLACEHOLDER,
      timestamp: PLACEHOLDER.split.first,
    )
  end
end
