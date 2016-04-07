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

    past_encounters = (1..5).map do |n|
      PLACEHOLDER
    end.compact

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
      dob: PLACEHOLDER,
      eyes: PLACEHOLDER,
      hair: PLACEHOLDER,
      height: PLACEHOLDER,
      image: PLACEHOLDER_IMAGE,
      license_number: PLACEHOLDER,
      license_state: PLACEHOLDER,
      name: PLACEHOLDER,
      needs: needs,
      past_encounters: past_encounters,
      preparer: preparer,
      race: PLACEHOLDER,
      safety_notes: PLACEHOLDER,
      sex: PLACEHOLDER,
      street_address: PLACEHOLDER,
      timestamp: PLACEHOLDER.split.first,
      type: PLACEHOLDER,
      veteran: PLACEHOLDER,
      weight: PLACEHOLDER,
    )
  end
end
