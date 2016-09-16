require "rms_incident_parser"
require "shared/parse_boolean_attribute"

describe RMSIncidentParser do
  describe "#arrested" do
    let(:attribute) { :arrested }
    let(:rms_key) { "CHBK_DISPO_ARRESTED" }

    it_should_behave_like "a boolean attribute is parsed out"
  end

  describe "#belligerent_uncooperative" do
    let(:attribute) { :belligerent_uncooperative }
    let(:rms_key) { "CHBK_BELLIGERENT_UNCOOPERATIVE" }

    it_should_behave_like "a boolean attribute is parsed out"
  end

  describe "#biologically_induced" do
    let(:attribute) { :biologically_induced }
    let(:rms_key) { "CHBK_BIOLOGICALLY_INDUCED" }

    it_should_behave_like "a boolean attribute is parsed out"
  end

  describe "#bizarre_unusual_behavior" do
    let(:attribute) { :bizarre_unusual_behavior }
    let(:rms_key) { "CHBK_BIZARRE_UNUSUAL_BEHAVIOR" }

    it_should_behave_like "a boolean attribute is parsed out"
  end

  describe "#casemanager_notice" do
    let(:attribute) { :casemanager_notice }
    let(:rms_key) { "CHBK_DISPO_CASEMANAGER_NOTICE" }

    it_should_behave_like "a boolean attribute is parsed out"
  end

  describe "#chemically_induced" do
    let(:attribute) { :chemically_induced }
    let(:rms_key) { "CHBK_CHEMICALLY_INDUCED" }

    it_should_behave_like "a boolean attribute is parsed out"
  end

  describe "#chronic" do
    let(:attribute) { :chronic }
    let(:rms_key) { "CHBK_DISPO_CHRONIC" }

    it_should_behave_like "a boolean attribute is parsed out"
  end

  describe "#crisis_clinic" do
    let(:attribute) { :crisis_clinic }
    let(:rms_key) { "CHBK_DISPO_CRISIS_CLINIC" }

    it_should_behave_like "a boolean attribute is parsed out"
  end

  describe "#disorderly_disruptive" do
    let(:attribute) { :disorderly_disruptive }
    let(:rms_key) { "CHBK_DISORDERLY_DISRUPTIVE" }

    it_should_behave_like "a boolean attribute is parsed out"
  end

  describe "#disorganize_communication" do
    let(:attribute) { :disorganize_communication }
    let(:rms_key) { "CHBK_DISORGANIZE_COMMUNICATION" }

    it_should_behave_like "a boolean attribute is parsed out"
  end

  describe "#disoriented_confused" do
    let(:attribute) { :disoriented_confused }
    let(:rms_key) { "CHBK_DISORIENTED_CONFUSED" }

    it_should_behave_like "a boolean attribute is parsed out"
  end

  describe "#dmhp_refer" do
    let(:attribute) { :dmhp_refer }
    let(:rms_key) { "CHBK_DISPO_DMHP_REFER" }

    it_should_behave_like "a boolean attribute is parsed out"
  end

  describe "#emergent_ita" do
    let(:attribute) { :emergent_ita }
    let(:rms_key) { "CHBK_DISPO_EMERGENT_ITA" }

    it_should_behave_like "a boolean attribute is parsed out"
  end

  describe "#excited_delirium" do
    let(:attribute) { :excited_delirium }
    let(:rms_key) { "CHBK_EXCITED_DELIRIUM" }

    it_should_behave_like "a boolean attribute is parsed out"
  end

  describe "#go_number" do
    it "strips whitespace and imports the value" do
      parser = RMSIncidentParser.new("GO_ID" => "   1234   ")

      expect(parser.go_number).to eq("1234")
    end
  end

  describe "#grat" do
    let(:attribute) { :grat }
    let(:rms_key) { "CHBK_DISPO_GRAT" }

    it_should_behave_like "a boolean attribute is parsed out"
  end

  describe "#halluc_delusion" do
    let(:attribute) { :halluc_delusion }
    let(:rms_key) { "CHBK_HALLUC_DELUSION" }

    it_should_behave_like "a boolean attribute is parsed out"
  end

  describe "#hopeless_depressed" do
    let(:attribute) { :hopeless_depressed }
    let(:rms_key) { "CHBK_HOPELESS_DEPRESSED" }

    it_should_behave_like "a boolean attribute is parsed out"
  end

  describe "#mania" do
    let(:attribute) { :mania }
    let(:rms_key) { "CHBK_MANIA" }

    it_should_behave_like "a boolean attribute is parsed out"
  end

  describe "#medically_induced" do
    let(:attribute) { :medically_induced }
    let(:rms_key) { "CHBK_MEDICALLY_INDUCED" }

    it_should_behave_like "a boolean attribute is parsed out"
  end

  describe "#mobile_crisis_team" do
    let(:attribute) { :mobile_crisis_team }
    let(:rms_key) { "CHBK_DISPO_MOBILE_CRISIS_TEAM" }

    it_should_behave_like "a boolean attribute is parsed out"
  end

  describe "#narrative" do
    it "pulls the narrative from the Oracle Clob object" do
      narrative = "Lorem Ipsum dolor si amet"
      clob = double(read:narrative)
      parser = RMSIncidentParser.new("CRISIS_NARRATIVE" => clob)

      expect(parser.narrative).to eq(narrative)
    end

    it "records the narrative as nil if it is empty" do
      clob = double(read: "")
      parser = RMSIncidentParser.new("CRISIS_NARRATIVE" => clob)

      expect(parser.narrative).to eq(nil)
    end

    it "handles nil" do
      parser = RMSIncidentParser.new("CRISIS_NARRATIVE" => nil)

      expect(parser.narrative).to eq(nil)
    end
  end

  describe "#neglect_self_care" do
    let(:attribute) { :neglect_self_care }
    let(:rms_key) { "CHBK_NEGLECT_SELF_CARE" }

    it_should_behave_like "a boolean attribute is parsed out"
  end

  describe "#no_action_poss_necc" do
    let(:attribute) { :no_action_poss_necc }
    let(:rms_key) { "CHBK_DISPO_NO_ACTION_POSS_NECC" }

    it_should_behave_like "a boolean attribute is parsed out"
  end

  describe "#out_of_touch_reality" do
    let(:attribute) { :out_of_touch_reality }
    let(:rms_key) { "CHBK_OUT_OF_TOUCH_REALITY" }

    it_should_behave_like "a boolean attribute is parsed out"
  end

  describe "#reported_at" do
    it "combines the date and time into a single Time" do
      parser = RMSIncidentParser.new(
        "REPORTED_ON_DATE" => "01/02/2015",
        "REPORTED_ON_TIME" => "114",
      )

      expect(parser.reported_at).to eq(DateTime.new(2015, 1, 2, 1, 14))
    end

    it "parses out 24h time" do
      parser = RMSIncidentParser.new(
        "REPORTED_ON_DATE" => "01/02/2015",
        "REPORTED_ON_TIME" => "1314",
      )

      expect(parser.reported_at).to eq(DateTime.new(2015, 1, 2, 13, 14))
    end

    it "handles times at zero-hour" do
      parser = RMSIncidentParser.new(
        "REPORTED_ON_DATE" => "01/02/2015",
        "REPORTED_ON_TIME" => "6", # 12:06
      )

      expect(parser.reported_at).to eq(DateTime.new(2015, 1, 2, 0, 6))
    end

    it "handles nil time" do
      parser = RMSIncidentParser.new(
        "REPORTED_ON_DATE" => "01/02/2015",
        "REPORTED_ON_TIME" => nil,
      )

      expect(parser.reported_at).to eq(DateTime.new(2015, 1, 2))
    end
  end

  describe "#resource_declined" do
    let(:attribute) { :resource_declined }
    let(:rms_key) { "CHBK_DISPO_RESOURCE_DECLINED" }

    it_should_behave_like "a boolean attribute is parsed out"
  end

  describe "#shelter" do
    let(:attribute) { :shelter }
    let(:rms_key) { "CHBK_DISPO_SHELTER" }

    it_should_behave_like "a boolean attribute is parsed out"
  end

  describe "#suicide_threat_attempt" do
    let(:attribute) { :suicide_threat_attempt }
    let(:rms_key) { "CHBK_SUICIDE_THREAT_ATTEMPT" }

    it_should_behave_like "a boolean attribute is parsed out"
  end

  describe "#threaten_violence" do
    let(:attribute) { :threaten_violence }
    let(:rms_key) { "THREATEN_VIOLENCE_YN_DK" }

    it_should_behave_like "a boolean attribute is parsed out"
  end

  describe "#treatment_referral" do
    let(:attribute) { :treatment_referral }
    let(:rms_key) { "CHBK_DISPO_TREATMENT_REFERRAL" }

    it_should_behave_like "a boolean attribute is parsed out"
  end

  describe "#unknown_crisis_nature" do
    let(:attribute) { :unknown_crisis_nature }
    let(:rms_key) { "CHBK_UNKNOWN_CRISIS_NATURE" }

    it_should_behave_like "a boolean attribute is parsed out"
  end

  describe "#unusual_fright_scared" do
    let(:attribute) { :unusual_fright_scared }
    let(:rms_key) { "CHBK_UNUSUAL_FRIGHT_SCARED" }

    it_should_behave_like "a boolean attribute is parsed out"
  end

  describe "#verbalization" do
    let(:attribute) { :verbalization }
    let(:rms_key) { "CHBK_VERBALIZATION" }

    it_should_behave_like "a boolean attribute is parsed out"
  end

  describe "#veteran" do
    let(:attribute) { :veteran }
    let(:rms_key) { "CRISIS_CONTACTED_VET_YN_UNK" }

    it_should_behave_like "a boolean attribute is parsed out"
  end

  describe "#voluntary_commit" do
    let(:attribute) { :voluntary_commit }
    let(:rms_key) { "CHBK_DSIPO_VOLUNTARY_COMMIT" }

    it_should_behave_like "a boolean attribute is parsed out"
  end

  describe "#weapon" do
    let(:attribute) { :weapon }
    let(:rms_key) { "WEAPON_YN_DK" }

    it_should_behave_like "a boolean attribute is parsed out"
  end

  describe "#xml_crisis_id" do
    it "imports the value directly" do
      parser = RMSIncidentParser.new("XML_CRISIS_ID" => 1234)

      expect(parser.xml_crisis_id).to eq(1234)
    end
  end
end
