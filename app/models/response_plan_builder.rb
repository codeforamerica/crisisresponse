class ResponsePlanBuilder
  def self.build(data)
    data = data.to_h

    action_plan_steps = [
      data["Step #1 (of action plan)"],
      data["Step #2 (of action plan)"],
      data["Step #3 (of action plan)"],
      data["Step #4 (of action plan)"],
      data["Step #5 (of action plan)"],
    ].compact

    past_encounters = (1..5).map do |n|
      data["Descriptions of Past Encounter (##{n})"]
    end.compact

    ResponsePlan.new(
      action_plan_steps: action_plan_steps,
      dob: data["Date of Birth"],
      eyes: data["Eye Color"],
      hair: data["Hair Color"],
      height: data["Height"],
      image: data["Image"],
      license: data["License Number"],
      name: data["Full Name"],
      past_encounters: past_encounters,
      race: data["Race"],
      sex: data["Gender"],
      type: data["What prompts you to write this plan?"],
      veteran: data["Veteran?"],
      weight: data["Weight"],
    )
  end
end
