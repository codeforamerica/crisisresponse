RSpec.shared_examples "it has an analytics token" do |parameter|
  it "skips an analytics token if it already exists in the DB" do
    existing = create(factory_name)
    allow(SecureRandom).to receive(:hex).
      and_return(existing.analytics_token, :new_analytics_token)

    new = create(factory_name)

    expect(new.analytics_token).not_to eq(existing.analytics_token)
    expect(new.analytics_token).to eq("new_analytics_token")
    expect(SecureRandom).to have_received(:hex).at_least(2).times
  end

  it "should generate an analytics token after create" do
    object = create(factory_name)

    expect(object.analytics_token).not_to be_nil
  end

  def factory_name
    described_class.to_s.underscore.to_sym
  end
end
