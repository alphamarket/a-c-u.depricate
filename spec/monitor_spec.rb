class Request
  @parameters = { }
  attr_accessor :parameters

  def initialize(controller, action, namespace: '')
    raise MissingController.new("Controller name should exist!") if not(controller and controller.is_a?(String) and controller.to_s.strip.length)
    raise MissingController.new("Action name should exist!") if not(action and action.is_a?(String) and action.to_s.strip.length)
    ctrl = controller.strip
    ctrl = "#{namespace.strip}/#{ctrl}".downcase
    @parameters = {
      controller: ctrl,
      action: action.strip.downcase
    };
  end
end
class User
  @symbol = nil
  attr_accessor :symbol
end

describe 'Monitoring' do
  it "test request" do
    request = Request.new("home", "index")
    expect(request.instance_variable_defined?(:@parameters)).to be true
    expect(request.parameters).to include :controller, :action
    expect(request.parameters).to all be_truthy
  end
  before(:all) {
    Rules.define do
      whois :everyone { true }
      whois :noone { false }
    end
  }
  context '.monitor' do
    it "should respond to request" do

    end
  end
end
