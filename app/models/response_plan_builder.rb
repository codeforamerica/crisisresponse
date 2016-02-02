class ResponsePlanBuilder
  def self.build(data)
    data = data.to_h
    ResponsePlan.new(
      dob: data["Date of Birth"],
      eyes: data["Eye Color"],
      hair: data["Hair Color"],
      height: data["Height"],
      image: data["Image"],
      license: data["License Number"],
      name: data["Full Name"],
      race: data["Race"],
      sex: data["Gender"],
      type: data["What prompts you to write this plan?"],
      weight: data["Weight"],
      veteran: data["Veteran?"],
    )
  end
end
