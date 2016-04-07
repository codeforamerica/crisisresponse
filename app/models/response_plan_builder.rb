class ResponsePlanBuilder
  PLACEHOLDER = "REPLACE ME"
  PLACEHOLDER_IMAGE = "https://randomuser.me/api/portraits/med/men/43.jpg"

  def self.build(data)
    data = data.to_h

    action_plan_steps = [
      PLACEHOLDER,
      PLACEHOLDER,
      PLACEHOLDER,
      PLACEHOLDER,
      PLACEHOLDER,
    ].compact

    past_encounters = [PLACEHOLDER]

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

    needs = (data["General Services / Needs"] || "").split(",").map(&:strip)

    ResponsePlan.new(
      action_plan_steps: action_plan_steps,
      city_state_zip: PLACEHOLDER,
      contacts: contacts,
      image: PLACEHOLDER_IMAGE,
      license_number: PLACEHOLDER,
      license_state: PLACEHOLDER,
      needs: needs,
      past_encounters: past_encounters,
      preparer: preparer,
      safety_notes: PLACEHOLDER,
      street_address: PLACEHOLDER,
      timestamp: PLACEHOLDER.split.first,
      type: PLACEHOLDER,
      veteran: PLACEHOLDER,
    )
  end
end
