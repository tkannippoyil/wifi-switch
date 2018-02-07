# --- @ADD_TO_BOOTSTRAPPER ---
shared_examples 'a model with a valid factory' do
  subject { -> { FactoryGirl.build(described_class) } }

  it 'is valid' do
    subject.call.should be_valid
  end

  it 'is unique' do
    expect { 2.times{subject.call} }.to_not raise_error
  end
end
# ---
