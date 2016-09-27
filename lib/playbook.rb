# frozen_string_literal: true

require "active_support/core_ext/hash/slice"

class Playbook
  ACKNOWLEDGE_FEELINGS = "Acknowledge feelings (fear, anxiety, hopelessness, anger)"
  ACTIVE_INTERVIEWING = "Active Interviewing (O.P.E.N. Model)"
  ASSESS_MEDICATIONS = "Assess whether they have been prescribed medications.  Are they currently taking their meds as prescribed?"
  ASSESS_SLEEP = "Assess when the last time they slept"
  ASSESS_SUICIDE = "Assess suicide lethality using the C.P.R. Method (Current Plan, Previous Behavior, Resources)"
  CHECK_BODY_LANGUAGE = "Ensure that body language is matching the verbal words that are being communicated"
  DETERMINE_CAUSE = "Attempt to identify underlying cause of feelings/behaviors"
  DETERMINE_CAUSE_OF_NEGLECT = "Attempt to determine cause of neglect.  If cognitive decline is suspected, a DHMP / GRAT referral would be appropriate"
  DIRECT_BOOKING = "Consider use of AMR for direct booking to KCJ if an arrest is warranted / necessary (Advise AMR it is for direct booking at time of request)"
  DONT_ARGUE_HALLUCINATIONS = "Don’t argue with Hallucinations or Delusions"
  DONT_PARTICIPATE_HALLUCINATIONS = "Don’t participate in the Hallucinations or Delusions with the person in crisis"
  ENSURE_RESOURCES_PRESENT = "Ensure adequate resources are on scene"
  ESTABLISH_BOUNDARIES = "Establish boundaries with the person in crisis.  Use “I” statements (ex: I am having a hard time understanding you because you are yelling)"
  FOCUS_ON_EMPATHY = "focus on emotional labeling and displaying empathy"
  IDENTIFY_HOOKS_AND_TRIGGERS = "Identify Hooks and Triggers (Hooks – Pull the String; Triggers – Deflect and Redirect)"
  IDENTIFY_SOURCES = "Ensure that all possible sources of the crisis are identified before attempting to find closure with the incident"
  MAKE_SAFE = "Make the scene safe"
  NOTIFY_SUPERVISOR = "Notify Supervisor"
  REASSURE_SAFETY = "Reassure them that they are safe while you are with them"
  REORIENT = "Attempt to re-orient to current place and time – Grounding Techniques"

  MAPPING = {
    suicide_threat_attempt: [
      ASSESS_SUICIDE,
      ACTIVE_INTERVIEWING,
      DETERMINE_CAUSE,
      IDENTIFY_HOOKS_AND_TRIGGERS,
      IDENTIFY_SOURCES,
    ],
    excited_delirium: [],
    halluc_delusion: [
      DONT_ARGUE_HALLUCINATIONS,
      DONT_PARTICIPATE_HALLUCINATIONS,
      ACKNOWLEDGE_FEELINGS,
    ],
    belligerent_uncooperative: [
      MAKE_SAFE,
      ENSURE_RESOURCES_PRESENT,
      NOTIFY_SUPERVISOR,
      ESTABLISH_BOUNDARIES,
      ACTIVE_INTERVIEWING,
      DIRECT_BOOKING,
    ],
    mania: [
      ACTIVE_INTERVIEWING,
      DETERMINE_CAUSE,
      ASSESS_SLEEP,
      ASSESS_MEDICATIONS,
      REASSURE_SAFETY,
    ],
    disorderly_disruptive: [
      MAKE_SAFE,
      ENSURE_RESOURCES_PRESENT,
      NOTIFY_SUPERVISOR,
      ESTABLISH_BOUNDARIES,
      ACTIVE_INTERVIEWING,
      DIRECT_BOOKING,
    ],
    hopeless_depressed: [
      ACKNOWLEDGE_FEELINGS,
      ACTIVE_INTERVIEWING,
      FOCUS_ON_EMPATHY,
      DETERMINE_CAUSE,
      CHECK_BODY_LANGUAGE,
    ],
    neglect_self_care: [
      DETERMINE_CAUSE_OF_NEGLECT,
      REASSURE_SAFETY,
      ACTIVE_INTERVIEWING,
    ],
    disorganize_communication: [
      ACTIVE_INTERVIEWING,
      "Assess for possible TBI. (Recent injury, vehicle collision, fight with blow to the head)",
      "Make one request at a time",
      "Keep requests simple",
      "Talk slowly",
      "Allow time for them to respond",
      "If TBI is suspected, limit emotional labeling.",
      "Limit the use of open-ended questions, or keep them extremely simple",
      "If TBI is not suspected, utilize normal O.P.E.N. Model",
    ],
    disoriented_confused: [
      REORIENT,
      ACKNOWLEDGE_FEELINGS,
      ACTIVE_INTERVIEWING,
      REASSURE_SAFETY,
    ],
    unusual_fright_scared: [
      ACKNOWLEDGE_FEELINGS,
      REASSURE_SAFETY,
      ACTIVE_INTERVIEWING,
      DETERMINE_CAUSE,
    ],
    bizarre_unusual_behavior: [
      ACTIVE_INTERVIEWING,
      REASSURE_SAFETY,
      CHECK_BODY_LANGUAGE,
    ],
    out_of_touch_reality: [
      REORIENT,
      DONT_ARGUE_HALLUCINATIONS,
      DONT_PARTICIPATE_HALLUCINATIONS,
      ACKNOWLEDGE_FEELINGS,
    ],
  }.freeze

  def initialize(mapping = MAPPING)
    @mapping = mapping
  end

  attr_reader :mapping

  def techniques_for_behaviors(behaviors)
    mapping.slice(*behaviors).values.flatten.uniq
  end
end
