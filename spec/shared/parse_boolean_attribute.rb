RSpec.shared_examples "a boolean attribute is parsed out" do
  it "parses empty values as false" do
    parser = RMSIncidentParser.new(rms_key => "")

    expect(parser.public_send(attribute)).to eq(false)
  end

  it "parses 'Yes' as true" do
    parser = RMSIncidentParser.new(rms_key => "Yes")

    expect(parser.public_send(attribute)).to eq(true)
  end

  it "parses 'Y' as true" do
    parser = RMSIncidentParser.new(rms_key => "Y")

    expect(parser.public_send(attribute)).to eq(true)
  end

  it "parses 'y' as true" do
    parser = RMSIncidentParser.new(rms_key => "y")

    expect(parser.public_send(attribute)).to eq(true)
  end

  it "parses 'No' as false" do
    parser = RMSIncidentParser.new(rms_key => "No")

    expect(parser.public_send(attribute)).to eq(false)
  end

  it "parses 'N' as false" do
    parser = RMSIncidentParser.new(rms_key => "N")

    expect(parser.public_send(attribute)).to eq(false)
  end

  it "parses 'n' as false" do
    parser = RMSIncidentParser.new(rms_key => "n")

    expect(parser.public_send(attribute)).to eq(false)
  end

  it "parses 'X' as true" do
    parser = RMSIncidentParser.new(rms_key => "X")

    expect(parser.public_send(attribute)).to eq(true)
  end

  it "parses 'x' as true" do
    parser = RMSIncidentParser.new(rms_key => "x")

    expect(parser.public_send(attribute)).to eq(true)
  end
end

