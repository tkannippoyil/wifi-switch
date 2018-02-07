# Shared examples for a method that removes an association between two models
# by destroying a joining model. For instance, Company#remove_employee destroys an Employment record.
#
# Expected parameters:
#   has_many_class: The has-many association for the described class (eg. Company HAS MANY Users)
#   through_class:  The class in the middle of the association (eg. Company has many Users THROUGH Employments)
#   method:         The method to call on the described object (eg. Company#remove_employee)
#
shared_examples 'a remove_association method' do |params|

  # Enables conversion of class names, eg. MyClassName => :my_class_name
  class Class
    def to_snake_case_symbol
      to_s.tableize.singularize.to_sym
    end
  end

  # Enables pluralisation of symbols, eg. :circle_membership => :circle_memberships
  class Symbol
    def pluralize
      to_s.pluralize.to_sym
    end
  end

  # Factory create the objects we want to test.
  let(:described_object) { FactoryGirl.create(described_class.to_snake_case_symbol)}
  let(:has_many_object)  { FactoryGirl.create(params[:has_many_class].to_snake_case_symbol)}

  # Get a symbol representation of the classes we are testing, eg. CircleMembership becomes :circle_membership.
  before :all do
    @described_class_key = described_class.to_snake_case_symbol
    @has_many_class_key  = params[:has_many_class].to_snake_case_symbol
    @through_class_key   = params[:through_class].to_snake_case_symbol
  end

  # Before each test, create the joining model between described_object and has_many_object.
  before :each do
    @instance_to_remove = FactoryGirl.create(params[:through_class],
      @described_class_key => described_object,
      @has_many_class_key  => has_many_object
    )
  end

  # The subject of each test is a lambda that calls the method we specified in the parameters.
  subject { -> {described_object.send(params[:method], has_many_object)} }

  context 'given valid arguments' do
    it "removes a #{params[:through_class]} record" do
      subject.should change(params[:through_class], :count).by(-1)
    end

    it "removes the correct #{params[:through_class]} record" do
      subject.call.should include(@instance_to_remove)
    end
  end

  context 'when called twice with the same arguments' do
    it 'has no effect' do
      subject.call
      subject.should_not change(params[:through_class], :count)
    end

    it 'throws no exceptions' do
      subject.call
      subject.should_not raise_error
    end
  end

end
