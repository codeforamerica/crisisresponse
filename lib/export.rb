class Export
  def self.page_views(time_range)
    output = "Time,Officer Name,Person Name,Person Date of Birth\n"
    views = PageView.
      includes(:officer, :person).
      where(created_at: time_range).
      all

    views.each do |view|
      output += [
        view.created_at,
        view.officer.name,
        '"' + view.person.display_name + '"',
        view.person.date_of_birth,
      ].join(",")

      output += "\n"
    end

    output
  end

  def self.active_plan_for_person_at_time(person, time)
    person.active_plan_at(time).to_json
  end
end
