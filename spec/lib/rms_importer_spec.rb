require "rails_helper"
require "rms_importer"
require "email_service"

describe RMSImporter do
  it "uses the credentials stored in the ENV variables" do
    allow(ENV).to receive(:fetch)
    allow(ENV).to receive(:fetch).with("RMS_USERNAME").and_return("username")
    allow(ENV).to receive(:fetch).with("RMS_PASSWORD").and_return("password")
    allow(ENV).to receive(:fetch).with("RMS_URL").and_return("url")
    stub_crisis_incidents

    RMSImporter.new.import

    expect(OCI8).to have_received(:new).with("username", "password", "url")
  end

  it "imports existing crisis incidents" do
    stub_crisis_incidents(
      {"GO_ID" => "123", "XML_CRISIS_ID" => 111},
      {"GO_ID" => "456", "XML_CRISIS_ID" => "222"},
    )

    expect do
      RMSImporter.new.import
    end.to change(RMS::CrisisIncident, :count).from(0).to(2)

    expect(connection).to have_received(:exec).with(RMSImporter::SQL_QUERY)

    expect(RMS::CrisisIncident.first.go_number).to eq("123")
    expect(RMS::CrisisIncident.first.xml_crisis_id).to eq(111)

    expect(RMS::CrisisIncident.second.go_number).to eq("456")
    expect(RMS::CrisisIncident.second.xml_crisis_id).to eq(222)
  end

  it "updates incidents with different information where the XML_CRISIS_ID match" do
    original = { "XML_CRISIS_ID" => 123, "PIN" => "1234" }
    match = { "XML_CRISIS_ID" => 123, "PIN" => "5678"  }
    mismatch = { "XML_CRISIS_ID" => "987654321" }

    stub_crisis_incidents(original)
    RMSImporter.new.import

    stub_crisis_incidents(
      match,
      mismatch,
    )

    expect { RMSImporter.new.import }.
      to change(RMS::CrisisIncident, :count).from(1).to(2)

    person = RMS::Person.find_by!(pin: "1234")
    matches = RMS::CrisisIncident.where(rms_person: person)
    expect(matches.count).to eq(0)
  end

  it "creates an RMS::Person for a crisis incident if it does not exist" do
    stub_crisis_incidents(
      "G1" => "JANE",
      "SURNAME" => "DOE",
    )

    expect do
      RMSImporter.new.import
    end.to change(RMS::Person, :count).from(0).to(1)

    person = RMS::Person.last
    expect(person.first_name).to eq("Jane")
    expect(person.last_name).to eq("Doe")
  end

  it "creates a Person for each RMS::Person" do
    stub_crisis_incidents(
      "G1" => "JANE",
      "SURNAME" => "DOE",
    )

    expect do
      RMSImporter.new.import
    end.to change(Person, :count).from(0).to(1)

    person = Person.last
    expect(person.first_name).to eq("Jane")
    expect(person.last_name).to eq("Doe")
  end

  context "when a matching RMS::Person already exists" do
    it "associates incidents with the existing person" do
      pin = "000000"
      person = create(:rms_person, pin: pin)
      stub_crisis_incidents("PIN" => pin)

      expect do
        RMSImporter.new.import
      end.not_to change(RMS::Person, :count)

      expect(person.crisis_incidents.count).to eq(1)
    end

    it "updates the RMS::Person record if it has changed" do
      pin = "000000"
      person = create(:rms_person, pin: pin, first_name: "Jan")
      stub_crisis_incidents("PIN" => pin, "G1" => "Jane")

      RMSImporter.new.import

      expect(person.reload.first_name).to eq("Jane")
    end
  end

  it "does not create a Person if the RMS::Person exists and has one" do
    stub_crisis_incidents(
      "G1" => "JANE",
      "SURNAME" => "DOE",
      "GO_ID" => "123",
    )
    RMSImporter.new.import
    stub_crisis_incidents(
      "G1" => "JANE",
      "SURNAME" => "DOE",
      "GO_ID" => "456",
    )

    expect do
      RMSImporter.new.import
    end.not_to change(Person, :count)
  end

  it "determines the person's PIN with info from the incident and GO record" do
    stub_crisis_incidents("PIN" => "111")

    expect do
      RMSImporter.new.import
    end.to change(RMS::Person, :count).from(0).to(1)

    expect(RMS::Person.last.pin).to eq("111")
  end

  it "pulls all applicable person attributes" do
    stub_crisis_incidents({})

    RMSImporter.new.import

    person = RMS::Person.last
    attributes = person.attributes.except("scars_and_marks", "location_name")

    attributes.each do |attribute, value|
      expect(value).not_to be_nil, "#{attribute} was not imported"
    end
  end

  it "pulls all applicable crisis incident attributes" do
    stub_crisis_incidents({})

    RMSImporter.new.import

    incident = RMS::CrisisIncident.last
    incident.attributes.each do |attribute, value|
      expect(value).not_to be_nil, "#{attribute} was not imported"
    end
  end

  describe "logging" do
    it "writes unprocessable data to a log file, along with the error" do
      message = "there was an error"
      allow(RMSIncidentParser).to receive(:new).and_raise(message)
      stub_crisis_incidents({ "XML_CRISIS_ID" => "222333444" })

      importer = RMSImporter.new
      expect { importer.import }.not_to raise_error

      filename = importer.unprocessable_log_file
      expect(File.read(filename)).to include(message)
      expect(File.read(filename)).to include("in `parse_sql_result'")
      expect(File.read(filename)).to include('"XML_CRISIS_ID"=>"222333444"')
    end

    it "records incident IDs that were not picked up by the query" do
      stub_crisis_incidents("XML_CRISIS_ID" => "123")
      stub_all_crisis_incident_ids("123", "456")

      importer = RMSImporter.new
      importer.import

      filename = importer.unimported_log_file
      expect(File.read(filename)).to include("456")
      expect(File.read(filename)).not_to include("123")
    end

    it "writes incidents to a log file when they have been tied to multiple people" do
      stub_crisis_incidents(
        { "XML_CRISIS_ID" => "123", "PIN" => "123" },
        { "XML_CRISIS_ID" => "123", "PIN" => "456" },
        { "XML_CRISIS_ID" => "456", "PIN" => "456" },
      )

      importer = RMSImporter.new
      importer.import

      filename = importer.duplicated_log_file
      expect(File.read(filename)).to match(/^123,.+,123,/)
      expect(File.read(filename)).to match(/^123,.+,456,/)
      expect(File.read(filename)).not_to match(/^456,.+,456,/)
    end
  end

  describe "threshold" do
    context "when the person has not been visible before" do
      it "makes them visible to patrol officers" do
        allow(ENV).to receive(:fetch)
        allow(ENV).to receive(:fetch).
          with("RECENT_CRISIS_INCIDENT_THRESHOLD").
          and_return(1)
        allow(EmailService).to receive(:send)

        person = create(:person, visible: false)
        rms_person = create(:rms_person, person: person)
        stub_crisis_incidents(
          "REPORTED_ON_DATE" => 1.week.ago.to_date.strftime("%m/%d/%Y"),
          "PIN" => rms_person.pin,
        )

        expect { RMSImporter.new.import }.to change(Visibility, :count).by(1)

        visibility = Visibility.last
        expect(visibility.person).to eq(person)
        expect(visibility.creation_notes).
          to eq("[AUTO] Person crossed the threshold of 1 RMS Crisis Incident")
        expect(person.reload).to be_visible

        expect(EmailService).to have_received(:send) do |message|
          expect(message.subject).
            to eq("[RideAlong Response] New Core Profile Generated - #{l(Date.today)}")
        end
      end
    end

    context "when the person is visible" do
      it "doesn't change their visibility" do
        stub_crisis_incidents
        person = create(:person)
        visibility = create(:visibility, person: person)

        expect { RMSImporter.new.import }.not_to change(Visibility, :count)

        expect(visibility.person).to eq(person)
        expect(person.reload).to be_visible
      end
    end

    context "when the person has previously been visible" do
      # TODO do we actually want to do this?
      it "doesn't change their visibility" do
        stub_crisis_incidents
        person = create(:person, visible: false)
        create(:visibility, :removed, person: person)

        expect { RMSImporter.new.import }.not_to change(Visibility, :count)

        expect(person.reload).not_to be_visible
      end
    end
  end

  private

  def stub_crisis_incidents(*overrides)
    incident_attributes = overrides.map do |override|
      default_incident_data.merge(override)
    end

    cursor = double
    allow(cursor).to receive(:fetch_hash).and_return(
      *incident_attributes,
      nil,
    )

    allow(connection).to receive(:exec).
      with(RMSImporter::SQL_QUERY).
      and_return(cursor)
    allow(OCI8).to receive(:new).and_return(connection)
  end

  def stub_all_crisis_incident_ids(*ids)
    results = ids.map do |id|
      { "XML_CRISIS_ID" => id }
    end

    cursor = double
    allow(cursor).to receive(:fetch_hash).and_return(*results, nil)

    allow(connection).to receive(:exec).
      with(RMSImporter::XML_CRISIS_IDS_QUERY).
      and_return(cursor)
    allow(OCI8).to receive(:new).and_return(connection)
  end

  def connection
    @connection ||= double(exec: double(fetch_hash: nil))
  end

  def default_incident_data
    {
      "XML_CRISIS_ID" => 1234,
      "GO_ID" => " 2015000123456     ",
      "S_VERSION" => "  TT_VERSION 1.0",
      "S_TEMPLATE" => "   CRISIS TEMPLATE",
      "INSERT_TIME" => "    2015-01-02 14:05:29 +0000",
      "TRANS_TYPE" => "     NARRATIVE",
      "REPORTED_ON_DATE" => "      01/01/2015",
      "REPORTED_ON_TIME" => "       134",
      "TEMPLATE_ID" => 13579,
      "REPORT_YEAR" => "         2015",
      "REPORT_NUMBER" => "          123456",
      "VERSION" => "           ",
      "TERRY_STOP_TEMPLATE" => "",
      "EVENT_RTYPE" => "GO",
      "REPORTED_BY" => " 9876",
      "REPORTED_BY_TRANS" => "   JOHNSON, MEREDITH E",
      "EVENT_RIN" => 1234567,
      "CHBK_DICV" => "    X",
      "CHBK_BODYCAM" => "     ",
      "CHBK_CITOFF_REQUESTED" => "",
      "CHBK_CITOFF_DISPATCHED" => "",
      "CHBK_CITOFF_ARRIVED" => "X",
      "CHBK_BIOLOGICALLY_INDUCED" => " ",
      "CHBK_MEDICALLY_INDUCED" => "",
      "CHBK_CHEMICALLY_INDUCED" => "",
      "CHBK_EXCITED_DELIRIUM" => "",
      "CHBK_UNKNOWN_CRISIS_NATURE" => "X",
      "CHBK_NEGLECT_SELF_CARE" => " ",
      "CHBK_DISORGANIZE_COMMUNICATION" => "X",
      "CHBK_DISORIENTED_CONFUSED" => " ",
      "CHBK_DISORDERLY_DISRUPTIVE" => "",
      "CHBK_UNUSUAL_FRIGHT_SCARED" => "",
      "CHBK_BELLIGERENT_UNCOOPERATIVE" => "",
      "CHBK_HOPELESS_DEPRESSED" => "",
      "CHBK_BIZARRE_UNUSUAL_BEHAVIOR" => "X",
      "CHBK_SUICIDE_THREAT_ATTEMPT" => " ",
      "CHBK_MANIA" => "",
      "CHBK_OUT_OF_TOUCH_REALITY" => "",
      "CHBK_HALLUC_DELUSION" => "",
      "CHBK_BEHAVIOR_OTHER" => "",
      "CHBK_WPN_KNIFE" => "",
      "CHBK_WPN_GUN" => "",
      "CHBK_WPN_OTH" => "",
      "CHBK_VERBALIZATION" => "X",
      "CHBK_HANDCUFFS" => " ",
      "CHBK_REPORTABLE_FORCE_USED" => "",
      "CHBK_DISPO_UNABLE_TO_CONTACT" => "",
      "CHBK_DISPO_CHRONIC" => "",
      "CHBK_DISPO_TREATMENT_REFERRAL" => "",
      "CHBK_DISPO_RESOURCE_DECLINED" => "",
      "CHBK_DISPO_MOBILE_CRISIS_TEAM" => "",
      "CHBK_DISPO_GRAT" => "",
      "CHBK_DISPO_SHELTER" => "",
      "CHBK_DISPO_NO_ACTION_POSS_NECC" => "X",
      "CHBK_DISPO_CASEMANAGER_NOTICE" => " ",
      "CHBK_DISPO_DMHP_REFER" => "",
      "CHBK_DISPO_CRISIS_CLINIC" => "",
      "CHBK_DISPO_EMERGENT_ITA" => "",
      "CHBK_DSIPO_VOLUNTARY_COMMIT" => "",
      "CHBK_DISPO_ARRESTED" => "",
      "CIT_CERTIFIED_YN" => "N",
      "SUPV_RESPONDED_SCENE_YN" => " N",
      "CRISIS_CONTACTED_LAST_NAME" => "      DOE",
      "CRISIS_CONTACTED_FIRST_NAME" => "  JANE",
      "CRISIS_CONTACTED_VET_YN_UNK" => "    No",
      "OTHER_BEHAVIOR_DESCR" => "     ",
      "WEAPON_YN_DK" => "No",
      "OTHER_WEAPON_TYPE" => " ",
      "THREATEN_VIOLENCE_YN_DK" => "No",
      "THREATENED_WHOM" => " ",
      "INJURIES_YN_DK" => "No",
      "INJURY_DESC" => " ",
      "INVOL_HOSPITAL_TRANSPORT_TO" => "",
      "VOL_HOSPITAL_TRANSPORT_TO" => "",
      "NO_ARR_BUT_CHARGEABLE_YN" => "",
      "CRISIS_NARRATIVE" => double(read: "Lorem Ipsum dolor si amet"),
      "PIN" => 123456789,
      "SDX" => " 4444",
      "LRN" => "  1",
      "SLOT" => "   1",
      "SURNAME" => "        DOE                                 ",
      "G1" => "    JANE                 ",
      "G2" => "           L              ",
      "G3" => "       ",
      "SEX" => "F",
      "ADDRESS" => "   1234 MAIN ST                                                                                      ",
      "APARTMENT" => "  ",
      "MUNICIPALITY" => "ED        ",
      "CITY" => " EDMONDS                                 ",
      "STATE" => "  WA",
      "ZIP" => "    9026-    ",
      "DOB" => Time.new(1975, 1, 2),
      "YOB" => "       1975",
      "RACE" => "        W",
      "HOME_AREA" => "         ",
      "HOME_PHONE" => "",
      "BUS_AREA" => "222",
      "BUSINESS_PHONE" => " 333-4444",
      "CELL_AREA" => "  ",
      "CELL_PHONE" => "",
      "MICROFILM" => "N",
      "EVENT_COUNT" => " 31",
      "ALT_PERSON_COUNT" => "  1",
      "ALIAS" => "   N",
      "COUNTY" => "    ",
      "DISTRICT" => "K     ",
      "ZONE" => " K2    ",
      "GRID" => "  2414  ",
      "X_COORDINATE" => "   ",
      "Y_COORDINATE" => "",
      "PLACE_NAME" => "",
      "DRIVERS_LICENSE" => "DOEJL123456        ",
      "SOI" => " WA",
      "LICENSE_CLASS" => "  ",
      "SSN" => "123-45-6789",
      "SOB" => " WA",
      "CAUTION" => "  M     ",
      "OCCUPATION" => "   UNEMPLOYED     ",
      "EMPLOYER" => "    ",
      "EMPLOYER_ADDRESS" => "",
      "INS_NUM" => "",
      "MARITAL_STATUS" => "",
      "LANGUAGE_SPOKEN" => "E ",
      "CITIZENSHIP" => " U",
      "DISABILITY" => "  ",
      "ETHNICITY" => "N",
      "HEIGHT" => " 5'6  ",
      "WEIGHT" => "  135",
      "COMPLEXION" => "   RUD",
      "BUILD" => "    S",
      "HAIR_COLOR" => "     GRY",
      "HAIR_STYLE" => "      L    ",
      "EYE_COLOR" => "       BRO",
      "LENS_TYPE" => "        ",
      "HANDED" => "",
      "FACIAL_HAIR" => "",
      "FACIAL_HAIR_COLOR" => "",
      "GANG_NAME" => "",
      "REMARKS" => "CAN GET IN \"RAGE\" MODE AND IS LOUD AND UNREASONABLE         ",
      "LAST_UPDATE_DATE" => "  012-05-08 00:00:00 +0000",
      "EMAIL_ADDR" => "",
    }
  end
end
