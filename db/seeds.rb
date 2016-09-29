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
ResponsePlan.create!(
  person: biff,
  author: officer,
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

martha = Person.create!(
  first_name: "Martha",
  last_name: "Tannen",
  middle_initial: "S",
  sex: "Female",
  race: "ASIAN (ALL)/PACIFIC ISLANDER",
  height_in_inches: 63,
  weight_in_pounds: 110,
  hair_color: "black",
  eye_color: "brown",
  date_of_birth: Date.new(1955, 7, 17),
  scars_and_marks: nil,
  location_name: nil,
  location_address: "",
)
ResponsePlan.create!(
  person: martha,
  author: officer,
  background_info: "Ms. TANNEN is a 60 y/o female who frequently calls 911 and has frequent contacts with law-enforcement to report several conspiracies in which she is the central figure and target, such as people referring to her as a _stripper cop_, working undercover, KC Sheriff_s, and people trying to steal the rights music she has written.  On occasion, she has also made calls regarding higher priority incidents to include someone pulling a gun on her in public.  ",
  private_notes: nil,
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
  description: "It is not uncommon for TANNEN to call 911 several times in a day to report the same information.  She often does this out of a desire for attention and someone with whom to talk.  She believes that officers have to listen to her and document her concerns.  It is believed that TANNEN calls 911, at least in part, in an effort to reduce anxiety, without having to directly confront the underlying cause of her anxiety. ",
  response_plan: martha.response_plans.last,
)
ResponseStrategy.create!(
  priority: 2,
  title: "Redirect her to her case manager or CRT MHP",
  description: "TANNEN is enrolled in services with DESC (case manager is Johanna Doe) though TANNEN recently _fired_ her. On 8/02/15, as documented in SC 2015-1234, Officer Smith and Jones (MHP) met with TANNEN and her case manager outside of her apartment and she was informed that she needed to consider alternatives to calling 911 as the topics she calls about are better addressed with her case manager.  TANNEN was informed that she could face false reporting charges during that meeting.  Since that meeting, TANNEN has been calling the CRT MHP several times a day, leaving voice mail messages, rather than calling 911, as she does not want to go to jail.  ",
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
  description: "TANNEN is very unlikely to be hospitalized if officers emergently detain her. Avoid emergent detention if at all possible.",
  response_plan: martha.response_plans.last,
)

def image(path)
  File.open(Rails.root.join("db", "seeds", "images", path))
end

Image.create!(source: image("tannen_biff/1.png"), person: biff)
Image.create!(source: image("tannen_gregory/1.png"), person: gregory)
Image.create!(source: image("tannen_martha/1.png"), person: martha)
Image.create!(source: image("tannen_martha/2.jpg"), person: martha)

SafetyConcern.create!(
  category: :assaultive_law,
  title: "Spit at an officer",
  description: "TANNEN spit at an officer while being arrested.",
  go_number: GO_NUMBER,
  occurred_on: Date.new(1998, 1, 10),
  response_plan: biff.response_plans.last,
)
SafetyConcern.create!(
  category: :weapon,
  title: "Had 9mm pistol at house",
  description: "TANNEN had a 9mm pistol in his house.",
  go_number: GO_NUMBER,
  occurred_on: Date.new(2005, 6, 8),
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
  (6..12).to_a.sample.times do
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

create_incidents_for(gregory)
create_incidents_for(biff)

# Create a recent incident
RMS::CrisisIncident.create(
  reported_at: 1.second.ago,
  go_number: GO_NUMBER,
  narrative: NARRATIVE,
  rms_person: gregory.rms_person,
  xml_crisis_id: "000000",
)

biff.aliases.create(name: "B-Tan")

gregory.update(visible: true)
martha.update(visible: true)
biff.update(visible: true)
