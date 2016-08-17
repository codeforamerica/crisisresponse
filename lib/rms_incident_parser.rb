require "active_support/core_ext/object/blank"

class RMSIncidentParser
  RMS_INCIDENT_BOOLEAN_ATTRIBUTES = {
    arrested: "CHBK_DISPO_ARRESTED",
    belligerent_uncooperative: "CHBK_BELLIGERENT_UNCOOPERATIVE",
    biologically_induced: "CHBK_BIOLOGICALLY_INDUCED",
    bizarre_unusual_behavior: "CHBK_BIZARRE_UNUSUAL_BEHAVIOR",
    casemanager_notice: "CHBK_DISPO_CASEMANAGER_NOTICE",
    chemically_induced: "CHBK_CHEMICALLY_INDUCED",
    chronic: "CHBK_DISPO_CHRONIC",
    crisis_clinic: "CHBK_DISPO_CRISIS_CLINIC",
    disorderly_disruptive: "CHBK_DISORDERLY_DISRUPTIVE" ,
    disorganize_communication: "CHBK_DISORGANIZE_COMMUNICATION",
    disoriented_confused: "CHBK_DISORIENTED_CONFUSED",
    dmhp_refer: "CHBK_DISPO_DMHP_REFER",
    emergent_ita: "CHBK_DISPO_EMERGENT_ITA",
    excited_delirium: "CHBK_EXCITED_DELIRIUM",
    grat: "CHBK_DISPO_GRAT",
    halluc_delusion: "CHBK_HALLUC_DELUSION",
    hopeless_depressed: "CHBK_HOPELESS_DEPRESSED",
    mania: "CHBK_MANIA",
    medically_induced: "CHBK_MEDICALLY_INDUCED",
    mobile_crisis_team: "CHBK_DISPO_MOBILE_CRISIS_TEAM",
    neglect_self_care: "CHBK_NEGLECT_SELF_CARE",
    no_action_poss_necc: "CHBK_DISPO_NO_ACTION_POSS_NECC",
    out_of_touch_reality: "CHBK_OUT_OF_TOUCH_REALITY",
    resource_declined: "CHBK_DISPO_RESOURCE_DECLINED",
    shelter: "CHBK_DISPO_SHELTER",
    suicide_threat_attempt: "CHBK_SUICIDE_THREAT_ATTEMPT",
    threaten_violence: "THREATEN_VIOLENCE_YN_DK",
    treatment_referral: "CHBK_DISPO_TREATMENT_REFERRAL",
    unknown_crisis_nature: "CHBK_UNKNOWN_CRISIS_NATURE",
    unusual_fright_scared: "CHBK_UNUSUAL_FRIGHT_SCARED",
    verbalization: "CHBK_VERBALIZATION",
    voluntary_commit: "CHBK_DSIPO_VOLUNTARY_COMMIT",
    weapon: "WEAPON_YN_DK",
  }.freeze

  RMS_INCIDENT_ATTRIBUTES = (
    RMS_INCIDENT_BOOLEAN_ATTRIBUTES.keys +
    [
      :go_number,
      :narrative,
      :reported_at,
      :xml_crisis_id,
    ]
  ).freeze

  RMS_INCIDENT_BOOLEAN_ATTRIBUTES.each do |attribute, rms_column_name|
    define_method(attribute) do
      parse_boolean_value(data.fetch(rms_column_name))
    end
  end

  def initialize(data)
    @data = data
  end

  def parsed_attributes
    RMS_INCIDENT_ATTRIBUTES.map do |attr|
      [attr, send(attr)]
    end.to_h
  end

  def xml_crisis_id
    data.fetch("XML_CRISIS_ID")
  end

  def go_number
    data.fetch("GO_ID").strip
  end

  def narrative
    narrative = data.fetch("CRISIS_NARRATIVE")

    if narrative
      narrative.read.presence
    end
  end

  def reported_at
    date = data.fetch("REPORTED_ON_DATE").strip
    time = "%04d" % data.fetch("REPORTED_ON_TIME").to_i
    hour = time[0...-2].to_i
    minute = time[-2..-1].to_i
    time = "#{date} #{hour}:#{minute}"
    DateTime.strptime(time, "%m/%d/%Y %k:%M")
  end

  private

  attr_reader :data

  def parse_boolean_value(value)
    ["Y", "y", "Yes", "X", "x"].include? value
  end
end
