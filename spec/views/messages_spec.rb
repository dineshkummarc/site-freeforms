require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "messages/show.html" do
  before :all do
    @message = Message.make( :read_at => Time.now )
  end

  before :each do
    assigns[:message] = @message

    render 'messages/show.html'
  end

  it "should contain sender info" do
    response.should have_text(/#{Regexp.quote( @message.data[1] )}/)
    response.should have_text(/#{Regexp.quote( @message.data[0] )}/)
  end

  it "should contain timestamps" do
    response.should have_text(/#{Regexp.quote( I18n.l( @message.created_at, :format => :long ) )}/)
    response.should have_text(/#{Regexp.quote( I18n.l( @message.read_at, :format => :long ) )}/)
  end
end

describe "forms/messages.html" do

  before :all do
    @form = Form.make( :fields => [
      Form::EmailField.new( :title => I18n.t( 'form_fields.email' ), :required => true ),
      Form::StringField.new( :title => I18n.t( 'form_fields.name' ) ),
      Form::StringField.new( :title => I18n.t( 'form_fields.title' ) ),
      Form::TextField.new( :title => I18n.t( 'form_fields.content' ) )
    ])

    @messages = [ Message.make( :read_at => Time.now, :form => @form ), Message.make( :read_at => Time.now, :form => @form ) ].paginate
  end

  before :each do
    assigns[:form] = @form
    assigns[:messages] = @messages

    template.stub!(:current_user).and_return(@form.user)

    render 'forms/messages.html'
  end

  it "should contain links to messages" do
    @messages.each do |msg|
      response.should have_text(/#{Regexp.quote( message_path( msg ) )}/)
    end
  end

  it "should contain messages sender name" do
    @messages.each do |msg|
      response.should have_text(/#{Regexp.quote( msg.data[1] )}/)
    end
  end

  it "should contain messages sender email" do
    @messages.each do |msg|
      response.should have_text(/#{Regexp.quote( msg.data[0] )}/)
    end
  end

  it "should contain delete icon" do
    response.should have_text(/icons\/delete\.png/)
  end
end

describe "forms/messages.html with unread" do
  before :all do
    @form = Form.make
    @messages = [ Message.make( :read_at => Time.now, :form => @form ), Message.make( :form => @form ) ].paginate
  end

  before :each do
    assigns[:form] = @form
    assigns[:messages] = @messages

    template.stub!(:current_user).and_return(@form.user)

    render 'forms/messages.html'
  end

  it "should contain unread icon" do
    response.should have_text(/icons\/newmail\.png/)
  end

end
