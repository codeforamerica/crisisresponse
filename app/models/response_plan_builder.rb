class ResponsePlanBuilder
  def self.build(data)
    data = data.to_h

    action_plan_steps = [
      data.fetch("Step #1 (of action plan)"),
      data.fetch("Step #2 (of action plan)"),
      data.fetch("Step #3 (of action plan)"),
      data.fetch("Step #4 (of action plan)"),
      data.fetch("Step #5 (of action plan)"),
    ].compact

    past_encounters = (1..5).map do |n|
      data.fetch("Descriptions of Past Encounter (##{n})")
    end.compact

    preparer = {
      name: data.fetch("What is your name?"),
      phone: data.fetch("What is the best phone number to reach you?"),
      team: data.fetch("Which team at SPD are you a part of?"),
    }

    contacts = [
      {
        name: data.fetch("Emergency Contact #1 - Name"),
        relationship: data.fetch("Emergency Contact #1 - Relationship"),
        phone: data.fetch("Emergency Contact #1 - Phone Number"),
        notes: data.fetch("Emergency Contact #1 - General Notes"),
      },
      {
        name: data.fetch("Emergency Contact #2 - Name"),
        relationship: data.fetch("Emergency Contact #2 - Relationship"),
        phone: data.fetch("Emergency Contact #2 - Phone Number"),
        notes: data.fetch("Emergency Contact #2 - General Notes"),
      },
    ]

    needs = (data["General Services / Needs"] || "").split(",").map(&:strip)

    ResponsePlan.new(
      action_plan_steps: action_plan_steps,
      city_state_zip: data.fetch("City, State, and Zipcode"),
      contacts: contacts,
      dob: data.fetch("Date of Birth"),
      eyes: data.fetch("Eye Color"),
      hair: data.fetch("Hair Color"),
      height: data.fetch("Height"),
      image: data.fetch("Image"),
      license_number: data.fetch("License Number"),
      license_state: data.fetch("State of License"),
      name: data.fetch("Full Name"),
      needs: needs,
      past_encounters: past_encounters,
      preparer: preparer,
      race: data.fetch("Race"),
      safety_notes: data.fetch("Weapons / Violence History: Notes"),
      sex: data.fetch("Gender"),
      street_address: data.fetch("Street Address"),
      timestamp: data.fetch("Timestamp").split.first,
      type: data.fetch("What prompts you to write this plan?"),
      veteran: data.fetch("Veteran?"),
      weight: data.fetch("Weight"),
    )
  end
end
