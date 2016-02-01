class ResponsePlanBuilder
  def self.build(data)
    data = data.to_h
    ResponsePlan.new(
      name: data["Full Name"],
      license: data["License Number"],
      type: data["What prompts you to write this plan?"],
    )
  end
end
