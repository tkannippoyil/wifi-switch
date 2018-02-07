shared_examples 'an add_association method' do |joining_model, is_idempotent = true|
  it "adds a #{joining_model} record" do
    subject.should change(joining_model, :count).by(1)
  end

  it "returns the newly-created #{joining_model} record"

  context 'when called twice with the same arguments' do
    if is_idempotent
      it 'has no effect' do
        subject.call
        subject.should_not change(joining_model, :count)
      end
    else
      it "adds a #{joining_model} record" do
        subject.call
        subject.should change(joining_model, :count).by(1)
      end
    end

    it 'throws no exceptions' do
      subject.call
      subject.should_not raise_error
    end
  end
end
