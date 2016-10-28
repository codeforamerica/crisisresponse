# frozen_string_literal: true

# This file should contain all the record creation
# needed to seed the database with its default values.
# The data can then be loaded with `rake db:seed`
# (or created alongside the db with db:setup).

RMS::CrisisIncident.destroy_all
RMS::Person.destroy_all

Alias.destroy_all
Contact.destroy_all
Image.destroy_all
ResponseStrategy.destroy_all
SafetyConcern.destroy_all
Trigger.destroy_all

PageView.destroy_all
Suggestion.destroy_all
ResponsePlan.destroy_all
Person.destroy_all
Officer.destroy_all

GO_NUMBER = "201600123456"

NARRATIVE = <<-NARRATIVE
Danish icing gingerbread gummies jujubes topping. Chocolate cake sweet roll pudding ice cream chocolate cake cookie toffee soufflé jelly beans. Bonbon sesame snaps biscuit danish jujubes marzipan cake croissant jelly beans. Tootsie roll cake wafer. Marzipan pie tiramisu gummies. Bonbon carrot cake oat cake carrot cake pastry toffee macaroon. Jujubes powder fruitcake toffee soufflé tiramisu. Jelly marzipan tootsie roll. Marshmallow chocolate bar toffee jelly beans croissant. Soufflé cake gummi bears jelly chocolate bar candy. Carrot cake lemon drops jelly beans candy canes cheesecake cake. Carrot cake brownie cookie cheesecake dragée tootsie roll muffin pudding. Toffee marshmallow icing caramels macaroon. Lollipop pudding chupa chups. Donut chupa chups chocolate danish. Croissant ice cream chocolate cake cake cotton candy pudding gummi bears cake.

Apple pie cake gingerbread gummi bears bear claw toffee. Sugar plum cupcake candy cookie wafer marzipan danish. Biscuit powder oat cake soufflé dessert. Cotton candy soufflé cake candy cupcake danish chupa chups candy pastry. Sweet roll dragée apple pie bear claw gingerbread cookie soufflé. Chupa chups tart candy canes pie donut. Cheesecake dragée chocolate marzipan dragée lollipop. Jelly jelly-o wafer liquorice cotton
NARRATIVE

officer = Officer.create!(
  name: "Ofc. John Doe",
  role: Officer::ADMIN,
  unit: "Crisis Response Team",
  title: nil,
  phone: "206-123-4567",
  username: "doe",
)

sergeant = Officer.create!(
  name: "Sgt Jones",
  role: Officer::ADMIN,
  unit: "Crisis Response Team",
  title: nil,
  phone: nil,
  username: "jones",
)

biff = Person.new.tap { |p| p.save!(validate: false) }
RMS::Person.create!(
  person: biff,
  pin: "000000",
  first_name: "Biff",
  last_name: "TANNEN",
  middle_initial: "R",
  sex: "Male",
  race: "WHITE",
  height_in_inches: 70,
  weight_in_pounds: 220,
  hair_color: "blonde",
  eye_color: "green",
  date_of_birth: Date.new(1980, 7, 14),
  scars_and_marks: "Small tattoo on arm",
  location_name: "The Morrison",
  location_address: "509 3rd Ave, Seattle, WA, 98104",
)
biff.update(location_supportive_housing: true)
ResponsePlan.create!(
  person: biff,
  author: officer,
  assignee: officer,
  background_info: "TANNEN, Biff (aka B-Tan) has a history of mental health issues and drug dependency. TANNEN has been diagnosed with Bi-Polar disorder and Poly-Substance abuse. He was last enrolled with DESC through the criminal justice liaison program back in 2010.  TANNEN is currently enrolled with DESC as terms of his probation. TANNEN has been using the cell phone number, 206.123.4556.  ",
  baseline: "Easily distracted, avoids eye contact",
  elevated: "Erratic movements, shouts threats",
  private_notes: nil,
)

gregory = Person.new.tap { |p| p.save!(validate: false) }
RMS::Person.create!(
  person: gregory,
  pin: "000000",
  first_name: "Gregory",
  last_name: "Tannen",
  middle_initial: "M",
  sex: "Male",
  race: "AFRICAN AMERICAN/BLACK",
  height_in_inches: 70,
  weight_in_pounds: 180,
  hair_color: "black",
  eye_color: "brown",
  date_of_birth: Date.new(1998, 5, 12),
  scars_and_marks: nil,
  location_name: nil,
  location_address: "S King St & 6th Ave, Seattle, WA, 98104",
)
ResponsePlan.create!(
  person: gregory,
  author: officer,
  background_info: "On 1/1/2015 3rd Watch - South officers responded to a Crisis Call involving Tannen, Gregory.  Gregory called his mother Angela and stated he was going to jump off of the nearby bridge. While officers were enroute, a second person called and stated she saw a male hanging from the bridge and another male attempting to hold him back.  As officers arrived they noticed Gregory on the west side of the bridge, and wrong side of the railing.  Two people were speaking with Gregory and holding his arms through the railing.       \r \rAfter officers secured Gregory, SFD cut bars on the bridge to bring Gregory safely off the ledge. Gregory was emergently detained to HMC for treatment; subsequently detained by DMHPs for a 72 hour hold. CRT determined Gregory has been in and out of treatment facilities most of his childhood life.  Due to the fact Greogry is no longer a juvenile; he cannot be held in the same facilities. Gregory has no history of assaultive behavior toward others.  ",
  private_notes: nil,
)

martha = Person.new.tap { |p| p.save!(validate: false) }
RMS::Person.create!(
  person: martha,
  pin: "000000",
  first_name: "Martha",
  last_name: "Adams",
  middle_initial: "S",
  sex: "Female",
  race: "AFRICAN AMERICAN/BLACK",
  height_in_inches: 63,
  weight_in_pounds: 110,
  hair_color: "black",
  eye_color: "brown",
  date_of_birth: Date.new(1985, 7, 17),
  scars_and_marks: nil,
  location_name: nil,
  location_address: "",
)
ResponsePlan.create!(
  person: martha,
  author: officer,
  assignee: sergeant,
  background_info: "Ms. ADAMS is a 60 y/o female who frequently calls 911 and has frequent contacts with law-enforcement to report several conspiracies in which she is the central figure and target, such as people referring to her as a _stripper cop_, working undercover, KC Sheriff_s, and people trying to steal the rights music she has written.  On occasion, she has also made calls regarding higher priority incidents to include someone pulling a gun on her in public.  ",
  private_notes: nil,
)

shana = Person.new.tap { |p| p.save!(validate: false) }
RMS::Person.create!(
  person: shana,
  pin: "000000",
  first_name: "Shana",
  last_name: "Wilson",
  middle_initial: "F",
  sex: "Female",
  race: "WHITE",
  height_in_inches: 63,
  weight_in_pounds: 130,
  hair_color: "blonde",
  eye_color: "blue",
  date_of_birth: Date.new(1985, 10, 5),
  scars_and_marks: "Small star tattoo on wrist",
  location_name: "The Morrison",
  location_address: "509 3rd Ave, Seattle, WA 98104",
)

Contact.create!(
  response_plan: biff.response_plans.last,
  name: "Ofc. Smith",
  relationship: "Supervising Officer",
  cell: "206-123-4678",
  notes: nil,
  organization: "DOC",
)
Contact.create!(
  response_plan: biff.response_plans.last,
  name: "Johanna Doe",
  relationship: "Case Manager",
  cell: "206-123-4657",
  notes: "If outside office hours, call Crisis Clinic.",
  organization: "DESC SAGE",
)
Contact.create!(
  response_plan: biff.response_plans.last,
  name: "Crisis Clinic",
  relationship: nil,
  cell: "206-461-3222",
  notes: "Alternate to Case Manager.",
  organization: nil,
)
Contact.create!(
  response_plan: gregory.response_plans.last,
  name: "Johanna Smith",
  relationship: "Case Manager",
  cell: "206-123-4678",
  notes: "Available during business hours. ",
  organization: "DESC",
)
Contact.create!(
  response_plan: gregory.response_plans.last,
  name: "Angela Tannen",
  relationship: "Mother",
  cell: "206-123-4657",
  notes: nil,
  organization: nil,
)
Contact.create!(
  response_plan: gregory.response_plans.last,
  name: "Bruce Tannen",
  relationship: "Father",
  cell: "206-123-4567",
  notes: nil,
  organization: nil,
)
Contact.create!(
  response_plan: martha.response_plans.last,
  name: "Johanna Smith",
  relationship: "Case Manager",
  cell: "206-123-4678",
  notes: "Available during business hours. ",
  organization: "DESC",
)

ResponseStrategy.create!(
  priority: 1,
  title: "Ensure no probation violations",
  description: "Stay Out of all East Precinct SODA Zones citywide (unless to receive medical care for employment or in transit through the zone); Do not consume nor possess any controlled substances; No contact with victim (See GO# 2015-12345). ",
  response_plan: biff.response_plans.last,
)
ResponseStrategy.create!(
  priority: 2,
  title: "If arrest / CBO, route charges thru Mental Health Court",
  description: "Based on TANNEN's ongoing willingness to engage in criminal actions, his unwillingness to address his mental health conditions and his requirement to not be involved in new criminal activity, officers who develop PC on TANNEN in new criminal matters are strongly encouraged to arrest/book on those matters with a referral to Mental Health Court.  ",
  response_plan: biff.response_plans.last,
)
ResponseStrategy.create!(
  priority: 3,
  title: "If contacted for criminal activity, notify Ofc. Smith",
  description: "If TANNEN is contacted for criminal, suspicious or Crisis behaviors, please notify Ofc. Smith. ",
  response_plan: biff.response_plans.last,
)
ResponseStrategy.create!(
  priority: 4,
  title: "Contact Case Manager",
  description: "If responding to a CRISIS call involving TANNEN, consider: attempt to utilize MCT; call his case managers at DESC (Johanna Smith). If after hours, call the Crisis Clinic for support in avoiding hospitalization. ",
  response_plan: biff.response_plans.last,
)
ResponseStrategy.create!(
  priority: 1,
  title: "If no Emergent Detention criteria, offer MCT, then Crisis Solutions Center",
  description: "If Gregory is contacted and does not meet Emergent Detention criteria, offer the MCT; followed by the Crisis Solution Center for stabilization. Gregory has a very involved family. He has an extensive history of suicide attempts; mostly via overdose. He lacks the coping skills and impulse control to deal with everyday problems. Gregory is very likely to attempt suicide again. When Gregory starts to get depressed, he will stop eating and drinking, he also becomes nonverbal; almost catatonic. Gregory is on an ever-changing regiment of medication to try and stabilize his condition; they have had a varying effect. ",
  response_plan: gregory.response_plans.last,
)
ResponseStrategy.create!(
  priority: 2,
  title: "If suicidal: use MCT and/or call case managers",
  description: "If responding to a CRISIS call involving Gregory and he claims to be suicidal, consider: attempt to utilize MCT; call his case managers at DESC (Johanna Smith). If after hours, call the Crisis Clinic for support in avoiding hospitalization. He often acts aggressively and makes suicidal statements and gestures when he is overwhelmed and frustrated.  He would benefit from MCT contact, when appropriate, to provide resources and alternatives to going to area emergency rooms. DESC staff are on board with this response plan. ",
  response_plan: gregory.response_plans.last,
)
ResponseStrategy.create!(
  priority: 3,
  title: "Contact Mother and Father",
  description: "Mother (Angela Tannen) and Father (Bruce Tannen) should be contacted.  Both have been educated on the smart 911 system to better help first responders.    ",
  response_plan: gregory.response_plans.last,
)
ResponseStrategy.create!(
  priority: 1,
  title: "Keep contacts as brief as possible, avoid feeding her need for attention",
  description: "It is not uncommon for ADAMS to call 911 several times in a day to report the same information.  She often does this out of a desire for attention and someone with whom to talk.  She believes that officers have to listen to her and document her concerns.  It is believed that ADAMS calls 911, at least in part, in an effort to reduce anxiety, without having to directly confront the underlying cause of her anxiety. ",
  response_plan: martha.response_plans.last,
)
ResponseStrategy.create!(
  priority: 2,
  title: "Redirect her to her case manager or CRT MHP",
  description: "ADAMS is enrolled in services with DESC (case manager is Johanna Doe) though ADAMS recently _fired_ her. On 8/02/15, as documented in SC 2015-1234, Officer Smith and Jones (MHP) met with ADAMS and her case manager outside of her apartment and she was informed that she needed to consider alternatives to calling 911 as the topics she calls about are better addressed with her case manager.  ADAMS was informed that she could face false reporting charges during that meeting.  Since that meeting, ADAMS has been calling the CRT MHP several times a day, leaving voice mail messages, rather than calling 911, as she does not want to go to jail.  ",
  response_plan: martha.response_plans.last,
)
ResponseStrategy.create!(
  priority: 3,
  title: "Offer Diversion Options",
  description: "Contact the MCT through dispatch. Offer Crisis Diversion Facility (CDF) for support and _a place to talk_ as an alternative (MCT can also facilitate this.) Alternatively, call DESC_s after-hours line through the KC Crisis Clinic.",
  response_plan: martha.response_plans.last,
)
ResponseStrategy.create!(
  priority: 4,
  title: "Avoid emergent ITA",
  description: "ADAMS is very unlikely to be hospitalized if officers emergently detain her. Avoid emergent detention if at all possible.",
  response_plan: martha.response_plans.last,
)

def image(path)
  File.open(Rails.root.join("db", "seeds", "images", path))
end

Image.create!(source: image("tannen_biff/1.png"), person: biff)
Image.create!(source: image("tannen_gregory/1.png"), person: gregory)
Image.create!(source: image("adams_martha/1.png"), person: martha)
Image.create!(source: image("adams_martha/2.jpg"), person: martha)
Image.create!(source: image("wilson_shana/1.png"), person: shana)

SafetyConcern.create!(
  category: :assaultive_law,
  title: "Spit at an officer",
  description: "TANNEN spit at an officer while being arrested.",
  go_number: GO_NUMBER,
  occurred_on: I18n.l(Date.new(1998, 1, 10)),
  response_plan: biff.response_plans.last,
)
SafetyConcern.create!(
  category: :weapon,
  title: "Had 9mm pistol at house",
  description: "TANNEN had a 9mm pistol in his house.",
  go_number: GO_NUMBER,
  occurred_on: I18n.l(Date.new(2005, 6, 8)),
  response_plan: biff.response_plans.last,
)
SafetyConcern.create!(
  category: :weapon,
  title: "Often armed with sharp instrument",
  description: "TANNEN had a box cutter concealed in his sleeve.",
  go_number: GO_NUMBER,
  response_plan: biff.response_plans.last,
)
SafetyConcern.create!(
  category: :chemical,
  title: "Needles have been found on Martha.",
  response_plan: martha.response_plans.last,
)

Trigger.create!(
  response_plan: biff.response_plans.last,
  title: "Don't send female officers",
  description: "TANNEN started shouting when a female officer arrived at the scene, declared that he wouldn’t talk to women.",
  go_number: GO_NUMBER,
)
Trigger.create!(
  response_plan: biff.response_plans.last,
  title: "Don't call TANNEN \"Biff\"",
  description: "TANNEN lost focus and kicked a parking meter after an officer called him Biff.",
  go_number: GO_NUMBER,
)

DeescalationTechnique.create!(
  description: 'Call him "Sarge." It helps him focus.',
  response_plan: biff.response_plans.last,
)
DeescalationTechnique.create!(
  description: "Mention his dog.",
  response_plan: biff.response_plans.last,
)

ResponsePlan.all.each do |plan|
  plan.update(approver: sergeant)
end

def create_incidents_for(person)
  (7..12).to_a.sample.times do
    behavior_attrs = RMS::CrisisIncident::BEHAVIORS.
      sample(3).
      map { |behavior| [behavior, true] }.
      to_h

    disposition_attrs = RMS::CrisisIncident::DISPOSITIONS.
      sample(2).
      map { |disposition| [disposition, true] }.to_h

    nature_attrs = { RMS::CrisisIncident::NATURE_OF_CRISIS.sample => true }

    RMS::CrisisIncident.create!(
      nature_attrs.
      merge(disposition_attrs).
      merge(behavior_attrs).
      merge(
        go_number: GO_NUMBER,
        narrative: NARRATIVE,
        reported_at: (1..40).to_a.sample.weeks.ago,
        rms_person: person.rms_person,
        xml_crisis_id: "000000",
      ),
    )
  end
end

create_incidents_for(biff)
create_incidents_for(gregory)
create_incidents_for(shana)
create_incidents_for(martha)

biff.recent_incidents.last.update!(veteran: true)
shana.recent_incidents.last.update!(veteran: true)

# Create a recent incident
RMS::CrisisIncident.create(
  reported_at: 1.second.ago,
  go_number: GO_NUMBER,
  narrative: NARRATIVE,
  rms_person: gregory.rms_person,
  xml_crisis_id: "000000",
)

biff.aliases.create(name: "B-Tan")

Visibility.create!(person: gregory, creation_notes: "Created as sample data")
Visibility.create!(person: martha, creation_notes: "Created as sample data")
Visibility.create!(person: biff, creation_notes: "Created as sample data")
Visibility.create!(person: shana, creation_notes: "Created as sample data")


CHECKBOX_ATTRIBUTES = [
  :weapon,
  :threaten_violence,
  :biologically_induced,
  :medically_induced,
  :chemically_induced,
  :unknown_crisis_nature,
  :neglect_self_care,
  :disorganize_communication,
  :disoriented_confused,
  :disorderly_disruptive,
  :unusual_fright_scared,
  :belligerent_uncooperative,
  :hopeless_depressed,
  :bizarre_unusual_behavior,
  :suicide_threat_attempt,
  :mania,
  :out_of_touch_reality,
  :halluc_delusion,
  :excited_delirium,
  :chronic,
  :treatment_referral,
  :resource_declined,
  :mobile_crisis_team,
  :grat,
  :shelter,
  :no_action_poss_necc,
  :casemanager_notice,
  :dmhp_refer,
  :crisis_clinic,
  :emergent_ita,
  :voluntary_commit,
  :arrested,
  :verbalization,
  :veteran,
]

rogers_events = "
fftffffffffffftffffffffffffffftft
fftffffffffftftfffffffffffffftfft
fftffffffffftftfffffffffffffftfft
ffffftffftfffftfffftfffffffffffft
fftfffffftftffffffftfffffffffffft
fftffftffffftffffffttffftfffftfft
fftffffffffffftfffftfffffftffffft
fftfffffftffffffffffffffftfffffft
fftfftffftftfttffffffffffftfftfft
fftfffffffffffttfffffffffffffftft
fftffffffffffftfffftftffffffftfft
fftfftfffffffttftfftffffftffftfft
ffffftffffffftftttffffffftfffffft
fftfffftffffffffftfffffffffffffft
ffffftfftffffttftfffffffffffftfft
fftfffffffffffffttfffffffffffftft
fftffftfftfftttfffftffffffffftfft
tftffffffttttftfffftffffffftftfft
fftfffffftfftfffffftftfffftffffft
ffffftffftffffffffffftffftfffffft
fftfffffftfffttfffffffffffffftfft
ffffftfftftfffffttfffffffffffftft
ffffftffftffffffffffftffffttfftft
ffffftffftfffttftffffftffffffffft
fftffffffffftffffffffftffffffffft
fftffffffftfffffttftfffffffffffft
fftffffffttfffffffffffffffftfftft
ffttftfffffffftfffftffffffffftfft
tftfftffftfttftfffftffffffffftfft
fftfffffffffffffffffffffftfffffft
fftfffffftfftffftfftfffffffffftft
ffffftffftftftttttffffffffffftfft
ffffftfftftfftfftfffffffftfffffft
fftfffftffffffttffffffffftfffffft
fftffffffffftffffffffffffftffffft
ffffftfffffftffffffffftffffffffft
fftffffffffffffffffftftftffffffft
fftffftffffftftftfftftffffffftfft
ffffftfffffftftfftftffffffffftfft
fftffffffffttftfffffffffffffffftt
fftffffffffftftfffftffffffffftfft
ffffftfffffftftffffttfffffffftfft
fftfffffffffffffffftffffttfffffft
fttfftftftftffttffffffffffffftfft
fftffffffffftftfffftfffffftftffft
fftffffftffffffftfffffffftfffffft
fftfftttftfttttftfftfttfffffttfff
"

angela_incidents = "
fftfffftffffftffffftffffftfffffft
fftfffftttftftffttftftffffffffftt
fftfffffffffftffffftfftffffffffft
fttfffftftftftfftfftftfffffffffft
ffffftfttfffftfftfffffffffffftfft
fftfffftttffftfftfffffffffffftfft
ffffftffffffftfffffffftffffffffft
fttfffftttttftftffffffffffffffftt
fftfftffftftftfffffffftffffffffft
fftfffftftfffffftfffffffftfffffft
ffttffftftffffftffffffffftfffffft
fftfffftftffffffffffffffftfffffft
fftfffftffffffffffffffffftfffffft
"

def add_incidents_for_person(incidents_string, rms_person, narratives)
  incidents_string.split("\n").each.with_index do |line, incident_index|
    if line.length > 0
      checkbox_attrs = line.chars.map.with_index do |char, index|
        [CHECKBOX_ATTRIBUTES[index], char == "t"]
      end.to_h

      RMS::CrisisIncident.create(checkbox_attrs.merge(
        rms_person: rms_person,
        go_number: GO_NUMBER,
        xml_crisis_id: "000000",
        reported_at: incident_index.weeks.ago,
        narrative: narratives[incident_index - 1] || NARRATIVE,
      ))
    end
  end
end

roger = Person.new.tap { |p| p.save!(validate: false) }
RMS::Person.create!(
  person: roger,
  pin: "000000",
  first_name: "Roger",
  last_name: "Smith",
  sex: "Male",
  race: "WHITE",
  height_in_inches: 70,
  weight_in_pounds: 211,
  hair_color: "bald",
  eye_color: "blue",
  date_of_birth: Date.new(1985, 1, 1),
  scars_and_marks: "",
  location_name: "Supportive Housing",
  location_address: "509 3 Av, Seattle, Wa, 98104",
  middle_initial: "A",
)
roger.update!(location_supportive_housing: true)

ResponsePlan.create!(
  person: roger,
  author: officer,
  approver: sergeant,
  approved_at: 2.months.ago,
  background_info: "SMITH has frequent contacts with law enforcement for suicidal ideation with superficial self-harm behaviors and agitation. SMITH frequently presents with suicidal ideation in an effort to meet secondary needs, such as shelter when homeless or attention, other than for accessing treatment. SMITH is enrolled in services with the Mental Health Services program. \r\n\r\nThe Crisis Diversion Facility will no longer accept SMITH. During recent care conferences, Mental Health Services / Supportive Housing staff strategized with CRT and are on board with this response plan.",
  private_notes: "",
  submitted_for_approval_at: 3.months.ago,
  baseline: nil,
  elevated: nil,
  assignee: officer,
  response_strategies_attributes: [
    {
      title: "If able, arrest or CBO; Route thru Mental Health Court",
      description: "Officers are encouraged to arrest and book SMITH, or complete CBO, if appropriate, when PC exists for any crime he commits (i.e. pedestrian interference, trespass).  Please route charges through mental health court. ",
    },
    {
      title: "If suicidal: use Mobile Crisis Team and/or call case managers",
      description: "If responding to a CRISIS call involving SMITH and he claims to be suicidal, consider: attempt to utilize Mobile Crisis Team; call his case managers at the Mental Health Services Program (Anna Doe and Francis Jones). \r\n\r\nIf after hours, call the Crisis Clinic for support in avoiding hospitalization. He often acts aggressively and makes suicidal statements and gestures when he is overwhelmed and frustrated.  He would benefit from Mobile Crisis Team contact, when appropriate, to provide resources and alternatives to going to area emergency rooms. Mental Health Services staff are on board with this response plan. ",
    },
    {
      title: "Avoid emergent ITA",
      description: "SMITH is very unlikely to be hospitalized if officers emergently detain him. Avoid emergent detention if at all possible.",
    }
  ],
  contacts_attributes: [
    {
      name: "Anna Doe",
      relationship: "Case Manager",
      cell: "206-444-1234",
      notes: "Ext. 5555",
      organization: "Mental Health Services"
    },
    {
      name: "Francis Jones",
      relationship: "Case Manager",
      cell: "206-444-1234",
      notes: "Ext. 5555",
      organization: "Mental Health Services"
    },
    {
      name: "Crisis Center",
      relationship: "MHS Support After Hours",
      cell: "206-444-0000",
      notes: "Have response plan on hand. Call after-hours for support in alternatives to hospitalization.",
    }
  ],
)

roger_narratives = [
  "I was on a SPD issued mountain bike in a fully authorized bicycle uniform with my partner Officer Johnson (0000). At approximately 1242 hours we were on routine patrol when I witnessed John Smith (W/M 01/01/1985) punch a light pole and proceed to walk into the street.  I contacted Smith and asked him what was wrong. Smith was calm and compliant and told me that he felt like killing himself. Smith said that approximately three days ago he had overdosed on his medication and was admitted to County Hospital in Seattle. Since Smith overdosed on his medication they took it from him and now he hasn't had his prescription meds in five days.  Smith asked if he could go to the hospital. I requested an AMR to transport Smith to County Hospital.  Smith was compliant and calm during our entire contact.  I screened the voluntary committal with A/Sgt Johnson at the precinct.",
  "*****THIS INCIDENT WAS CAPTURED ON ICV. I was on uniform patrol in a fully marked vehicle with my partner Officer Johnson. We responded to a suicidal call. The subject Smith is a chronic caller who is known to both Officer Johnson and me. We contacted Smith who initially disregarded officers and made a show of being angry and punching the walls. Smith was hitting the walls hard enough to make noise, but not hard enough to cause damage. When we did not call for Fire or AMR to report to the scene Smith elevated her behavior and began repeating that he was not safe with himself. He then began to cry. I spoke to staff who stated Smith had been trying to get attention \"all day\" and had tried repeatedly to get staff to give him \"meds\" ahead of schedule. Staff said with all of this Smith had still been happy and laughing. Staff stated this all changed when Smith placed marijuana on the counter. After telling multiple times staff pushed the marijuana off onto the floor. This sent Smith into a fit of rage. He began throwing things at staff and stated he was going to kill himself. Officer Hewitt and I took turns talking to Smith and were able to get him to calm down. We were very frank with him about what we believed would happen if he was sent to the hospital. We also re-enforced her good behaviors. This seemed to calm Smith who agreed that going to the hospital would do him no good because they would most likely discharge him immediately. Smith stated he was having difficulty managing his medications and was hoping to see his case worker in the morning. Smith stated he would go to his room and make every effort to get to his appointment in the morning. SPD business cards with Officer Johnson and my name, serial number, and the incident number were given to Smith and Supportive Housing staff.",
  "ICV was used.  On the listed date and time, I was working a two officer car with Officer Johnson. We were on a call at the Supportive Housing in Seattle. While on the call I onviewed a disturbance, involving Smith and the MHS staff.   Adams explained that overnight the staff had to bar Smith's fiance from the premises and also took away Smith's guest privleges. Smith became very upset and began yelling profanities at the staff members as well as punching walls. Adams stated that Smith never threatened physical violence against them or assaulted anyone. Staff was concerned that Smith may damage property with because of his behavior, but Smith had not broken anything at that point in time.  When we arrived Smith assumed that the staff had called police because of his behavior. I heard Smith say that he was glad police had arrived in case he did something then he could go to jail. Once officers explained the seriousness of the situation to Smith he calmed down and stated that he would be leaving soon to meet with his payee.  I explained to staff that I would be writing a report and documenting the incident.  Business card and case number provided.",
  "I was working patrol in a marked City of Seattle Police vehicle. I was in full uniform. The patrol vehicle is equipped with a digital in car video system which recorded my involvement. We were dispatched to Mental Health Services.  On arrival I contacted Smith. Smith is well known to officers for his multiple complaints of potential self harm and crisis issues. He also has well documented mental health diagnosis and a SPD crisis plan.  Smith's fiance said that Smith had just taken a handful or her medication. Staff also said that Smith took a three day supply of some of his medications. They said poison control said the medications taken were not enough to overdose, but that he might become lethargic. They said when he began getting a \"a little loopy\" they called 911.  Smith was hard to focus, but he said he only took the medication his sleep and denied doing it for self harm. He had a lot of belongings and his rat with him and he said he was trying to move to suburbs with his fiance. SFD stated that the medication taken was not enough to overdose or would not cause an overdose. Alcohol was also a factor and Smith was alert and oriented, but I do not believe he was an imminent threat to himself.  I provided Smith and his fiance a ride to the ferry dock.",
  "I was uniformed and in a marked patrol car. I have worked in patrol in the for approximately eighteen years, on all watches. On this day I was working solo when I heard dispatch broadcast the call a caller reporting he was suicidal. Smith is a known, there are two hazard flags linked to him within the last year.  Smith also flagged as being mental in RMS.   I was only a few blocks away. While I was waiting for my back-up I watched Smith walk away from the Supportive Housing facility. A few minutes as my back up was arriving I saw him walk back into the facility. I went in to speak with him and his case manager, Francis Jones.  He told me for about the last year he has been working with Smith on coping skills to help him through times of emotional distress.  Jones said he believed taking Smith to the hospital for a psychiatric evaluation would be detrimental, and would only further ingrain the behavior he has been displaying.  Jones also said when Smith is in an attention seeking behavior mode and receives what he wants it only exacerbates his mental illness.   He convinced him to take a walk with him to talk out options other than calling 911 after he wants to kill himself. Jones and Smith walked off together, I left the immediate area to write my report. I asked dispatch to let me know if 911 center received more calls involving Smith.",
  "I am familiar which Smith from a few previous encounters.  He lives in Seattle and gets his medication at the Mental Health Services. Today he was very depressed, reporting it the anniversary of he sister's death. He told me County Hospital had seen him as recently as yesterday; none of the DMHPs who evaluated him believed inpatient treatment was appropiate. I spoke with his case worker of almost a year, Francis Jones.  He told me there is a plan in place for Smith; she is choosing not to follow through with coping mechanisms they have set up for her.  Jones suggestion was to have Smith walk outside with him to help him calm down and lift his mood. He agreed, they left the Supportive Housing facility together. SFD was the first to evaluate Smith for this specic 911 call he placed saying he wanted to die.  On of the medics imformed me his concern was, there was chance of a interstinal puncture. Smith declined medical assistance.",
]

add_incidents_for_person(rogers_events, roger.rms_person, roger_narratives)
Image.create!(source: image("smith_roger/1.png"), person: roger)

angela = Person.new.tap { |p| p.save!(validate: false) }
RMS::Person.create!(
  person: angela,
  pin: "000000",
  first_name: "Angela",
  last_name: "SMITH",
  sex: "Female",
  race: "WHITE",
  height_in_inches: 70,
  weight_in_pounds: 110,
  hair_color: "black",
  eye_color: "brown",
  date_of_birth: 28.years.ago,
  location_address: "501 5th Street, Seattle, WA, 98108",
  middle_initial: "B",
)
angela.update!(location_supportive_housing: true)

=begin
ResponsePlan.create!(
  person: angela,
  author: officer,
  approver: sergeant,
  approved_at: 4.days.ago,
  background_info: "SMITH is a high utilizer of 9-1-1 services.",
  response_strategies_attributes: [
    {
      title: "Can be assaultive to officers; Does not like women and police",
      description: "SMITH has an RMS caution entry for being assaultive to and threatening law enforcement. Case management mentioned that SMITH does not like the police and she does not like men. When agitated she often responds well with structure and humor. ",
    },
    {
      title: "Ask \"Who am I speaking with today?\"",
      description: "It is believed that SMITH may have a dissociative disorder in addition to other mental health diagnoses.  As such, case managers have found it useful to ask of SMITH something similar to, \"Who am I speaking with today.\"  She may present as an adult or a scared child.  ",
    },
    {
      title: "If not 'Christina\", ask to speak to Christina (specific personality)",
      description: "SMITH's case manager suggests that we consider trying to speak with \"Christina\": \"Are you Christina?\" or \"Can I talk to Christina?\" \r\n\r\n\"Christina\" is the most controlled and has the most insight into what she needs. ",
    },
    {
      title: "If 'Amanda' (alternative personalities)",
      description: "\"Amanda\" is the most aggressive personality and considers herself the protector.  SMITH's case manager believes that if you are talking with \"Ashley\", it may be calming if she is assured that you are there to help, not hurt her. \r\n\r .",
    },
    {
      title: "Contact Case Managers - Mental Health Services",
      description: "SMITH is currently tiered with Mental Health Services, but they are looking to place her with Community Health Services where she can receive more care.  Her case manager and support team at Mental Health Services are Francis Jones and/or Jones's supervisor, Amanda Doe.",
    }
  ],
  contacts_attributes: [
    {
      name: "Francis Jones",
      relationship: "Case Manager",
      cell: "206-444-1234",
      notes: "Ext. #1243",
      organization: "Mental Health Services"
    },
    {
      name: "Anna Doe",
      relationship: "Supervisor",
      cell: "206-444-1234",
      notes: "Ext. 1234",
      organization: "Mental Health Services"
    }
  ],
)
=end

angela_narratives = [
  "On 6-9-16 I was dispatched to the alley behind Smith's address due to a neighbor's complaint that a woman was banging on trash cans.  The call was an hour old when I was dispatched.  Radio advised that they had recieved multiple calls from the woman banging on the trash cans, later identified as Smith.  Third watch had responded several times due to crisis disturbances in reference to Smith.  Radio advised that someone had broken a window at the nearby Fire Station, and also that Smith reported having a cut on her hand.  Third watch advised that there was no P/C for Smith's arrest.  When I arrived, there was no one in the alley causing a disturbance.  I sent an email to CRT requesting his unit follow-up with Smith due to the fact that she has been contacted by police multiple times over the past few weeks.  Just after sending the email, Smith called 911 and said she needed police.  I responded to her address and knocked on her window (it is not possible to get to her front door due to locked gates).  Smith looked at me out the window, showed me a small cut on her right hand, and said she wanted me to 'note' that it was there.  Then she yelled obsenities at me and said she didn't want to have anything to do with police.  Then she opened another window, spoke/grunted in a language other than English, and threw several items on the ground.  She continued to yell obsenities at me and repeated that she didn't want police assistance.  A short time later offices responded to the overpass due to a 911 complaint of a female, that matched Smith's description, who was in the street and appeared high.  I located Smith a couple blocks away.  She yelled obsenities again and walked away.  The complainant didn't want contact, and I was not able to determine for sure if Smith was the person who had been in the road.  When I saw her she was very angry and agitated, but she was on the sidewalk.  She walked home saying she was going to feed her cats.  Most of what she said didn't make sense, and at times it seemed as if she were talking to people that weren't there.  Smith said she has multiple personalities.  Today she seemed to be alternating beween 'Ashley' and 'Amanda'.  I screened the arrest, and Smith was transported to the Jail.  I requested mental health court.  I sent another email to CRU informing them of Smith's arrest.",
  "Smith called 911 and requested that the Fire Department and Police Department respond to her address.  Smith told dispatch that she committed a crime and wanted to go to jail.  Also, that she was having medical problems as well as mental problems.  I have contacted Smith several times in the past in relation to crisis issues, and I am familiar with her situation.  Smith changes identity (according to his case manager).  This morning Smith identified at the 'Ashley''.  I arrived, along with other officers, and contacted the Fire Department who had already talked to Smith.  They said she didn't need medical attention, but that she wanted to be arrested.  I asked Smith why he wanted to be arrested.  She said she needed to go to jail because she stole a skate board some time over the past two months.  I told Smith that I could write a report, but I would not be able to book her into jail.  Smith said that going to the hospital would be a good second option, but she didn't want to go via AMR due to the cost.  Smith wanted to go to the hospital partly because she lost some of her prescription medications.  She was lucid this morning, and I didn't see any reason to send Smith to the hospital involuntarily.  I asked Smith if she would be willing to talk to the Mobile Crisis Team, and she said she was.  I called the MCT, and they responded.  They were able to take Smith to the hospital.  Before leaving, Smith thanked me for not booking her into jail.",
  "Smith (who sometimes goes by Amanda) called to report a theft.  I am familiar with Smith due to multiple contacts in relation to crisis behavior.  Today Smith reported that she was at the skate park the other day hanging out with some neighbor kids.  She thinks one of the kids took her keys.  Smith said the kid lives in an apartment nearby. Smith tried to talk to the kid's sisters about the keys, but hasn't been able to get them back yet.  Smith said she didn't want the police to make a big deal out of the incident, she just wanted it reported.  Smith did exhibit some behavior today consistent with her crisis tendencies.  Smith had trouble staying on track with the story she was telling, and appeared to have some trouble organizing her thoughts.  Overall, she was calm today and no police action was necessary in relation to crisis behavior.  I provided her with a card and case number for the theft.  Note:  The missing keys include a bike lock key and a mail key.",
  "I saw Smith in the middle of the street, walking near the center line.  I have contacted Smith several times in the past due to crisis issues, and I recognized her. Smith was blocking traffic (myself and a garbage truck).  She was wearing a bath robe and underwear.  When she saw me, she turned toward my patrol car, opened her robe, and exposed herself from the waist up.  I activated my emergency flashers, and Smith walked away from me.  I tried to talk to her, but she just yelled expletives at me and continued to walk away.  I requested a CRT unit to respond, but none were available at this hour (I am CIT).  While I was waiting for other units to arrive, Smith made it back to her apartment complex.  This is a square shaped apartment complex with a gated court yard in the center.  Smith came out onto the sidewalk and threw a glass container across the street.  When other officers arrived I tried to talk to her over the gate.  She wouldn't answer questions, but she did throw several items over the gate in our direction (a walker and a another glass container; she also threw a vacuum cleaner over the opposite gate).  At one point Smith went inside her apartment and opened a window to yell at us.  I requested that she come outside to talk to us, but she refused.  Smith continued to yell expletives at us, and at one point she said, in English, that she didn't speak our language.  After Smith went inside her apartment we were able to gain access to the court yard.  Smith turned out all the lights in her apartment, and several minutes went by without any noise or contact.    At that point we didn't have cause to enter her apartment without permission, and it was clear she wasn't coming out.  I had the other officers move their patrol cars so that it would appear as if we left the area.  I waited inside the court yard with other officers to see if Smith would come out and cause a disturbance if she thought we left.  Her apartment remained dark, and we didn't hear any noise.  I decided it was best to leave with the hope that she would get some sleep.",
  "I was working the marked patrol unit in Seattle.  I responded to a person in crisis.  Radio reported that the complainant would be waiting out front of the listed address and that they want police to call the mobile crisis team.  I arrived to the listed location with my partner.  I contacted Smith.  Smith is reporting that she called 911 to get in touch with the mobile Crisis Team.  Smith states that she missed the Hope link bus that would take her home.  Smith reports that she has multiple personality issues and takes medications.   She said that she has no thoughts of harming herself or anyone else tonight.  Her main concern is to get a ride home so she can take care of her pets and have her medications.  She has multiple bags and luggage items with her and is unable to carry everything home.  I called the Mobile Crisis team for Smith and let them know what was going on tonight.  They said they would be by to help Smith get home. Smith states that she feels fine waiting by herself until the MCT arrives.  I confirmed that Smith was safe and let her know that if anything changes she can call 911 back.",
  "I was dispatched to check for someone walking in the middle of the street and throwing bricks around. I located the subject. I asked the subject if they were okay and if they needed any assistance. She said something about her cat and something about God. She then climbed up some metal scaffolding located in the park. The scaffolding was approximately 20-25 feet high. It was too dangerous for officers to go up there and attempt to have a dialogue with her. She began to scream about her \"batteries being low and needed lithium to charge them\". She then took off most of her clothes and showed her buttocks to officers. I was able to position my in car camera to get her actions on video. I immediately called for a CIT Unit to respond.   Once she was done screaming on top of the scaffolding she grabbed her sweat pants and climbed down. She wrapped the sweat pants around her head and took off running in the middle of the road. Officers were able to intercept her mid block. Officers were concerned she may get hit by a car. At this time CRT arrived on scene.   She then climbed into some sticker bushes with bare feat. It was obvious the subject was in some sort of crisis and was not able to care for herself. The CRT Officer asked the subject her name. She replied \"Amanda\". MHP knew the subject from previous contacts as Smith. A routine records check showed the subject was assaultive towards officers and needs mental health care. CRT Officer explained to Smith that we were detaining her for her own safety. Smith then stated we were making her feel \"purple\". Smith did have an injury on her face, her cheek and eye were all swollen. When asked about it and said she was punched in the face by a black guy who lives in a nearby apartment building. She said she called 911 last night but I am unable to find any record of it. She then began to make animal noises.   Due to the fact that Smith was running in the road, was climbing scaffolding and taking her clothes off, was saying things that did not make sense and had an injury on her face that most likely needed some medical attention officers felt she needed to go to the hospital. AMR responded to the scene. Smith was transported to hospital for an involuntary commitment. MHP was able to get me Smith's case manager's information. Her case manager is Francis Jones at Mental Health Services. Smith was sent to the hospital at the same location for running into traffic.",
]

Image.create!(source: image("smith_angela/1.png"), person: roger)

add_incidents_for_person(angela_incidents, angela.rms_person, angela_narratives)
Image.create!(source: image("smith_angela/1.png"), person: angela)
