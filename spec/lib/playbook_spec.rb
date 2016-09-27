require "playbook"

describe Playbook do
  describe "#techniques_for_behaviors" do
    it "returns matching techniques" do
      playbook = Playbook.new(foo: [:bar, :baz])

      techniques = playbook.techniques_for_behaviors([:foo])

      expect(techniques).to eq([:bar, :baz])
    end

    it "de-duplicates matching techniques" do
      playbook = Playbook.new(
        behavior_1: [:technique_1, :technique_2],
        behavior_2: [:technique_1, :technique_3],
      )

      techniques = playbook.techniques_for_behaviors([:behavior_1, :behavior_2])

      expect(techniques).to eq([:technique_1, :technique_2, :technique_3])
    end

    it "does not include inappropriate techniques" do
      playbook = Playbook.new(
        behavior_1: [:technique_1, :technique_2],
        behavior_2: [:technique_1, :technique_3],
      )

      techniques = playbook.techniques_for_behaviors([:behavior_1])

      expect(techniques).not_to include(:technique_3)
    end
  end
end
