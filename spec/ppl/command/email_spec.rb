
describe Ppl::Command::Email do

  before(:each) do
    @command = Ppl::Command::Email.new
  end

  describe "#name" do
    it "should be 'email'" do
      @command.name.should eq "email"
    end
  end

  describe "#execute" do

    before(:each) do
      @contact = Ppl::Entity::Contact.new
      @service = double(Ppl::Service::EmailAddress)
      @storage = double(Ppl::Adapter::Storage)
      @input = Ppl::Application::Input.new
      @output = double(Ppl::Application::Output)
      @list_format = double(Ppl::Format::AddressBook)
      @show_format = double(Ppl::Format::Contact)
      @storage.stub(:require_contact).and_return(@contact)
      @storage.stub(:save_contact)
      @command.storage = @storage
      @command.email_service = @service
      @command.list_format = @list_format
      @command.show_format = @show_format
    end

    it "should list all email addresses by default" do
      @storage.should_receive(:load_address_book).and_return(@address_book)
      @list_format.should_receive(:process).and_return("imagine this is a list")
      @output.should_receive(:line).with("imagine this is a list")
      @command.execute(@input, @output)
    end

    it "should show a single contact's addresses if one is specified" do
      @input.arguments << "jdoe"
      @storage.should_receive(:require_contact).and_return(@contact)
      @show_format.should_receive(:process).and_return("imagine this is a list")
      @output.should_receive(:line).with("imagine this is a list")
      @command.execute(@input, @output)
    end
    
    it "should delegate to the service layer to add a new email address" do
      @input.arguments = ["jdoe", "jdoe@example.org"]
      @storage.should_receive(:require_contact).and_return(@contact)
      @service.should_receive(:add).with(@contact, "jdoe@example.org")
      @command.execute(@input, @output)
    end

    it "should delegate to the service layer to remove an email address" do
      @input.arguments = ["jdoe", "jdoe@example.org"]
      @input.options[:delete] = true
      @storage.should_receive(:require_contact).and_return(@contact)
      @service.should_receive(:remove).with(@contact, "jdoe@example.org")
      @command.execute(@input, @output)
    end

  end

end

