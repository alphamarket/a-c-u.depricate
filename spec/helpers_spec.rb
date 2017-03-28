class ACUHelper
  include Helpers
  include ::RSpec::Matchers
  
  def test_protected_pass rspec
    for arg in [@hi, @sec_arg] do
      expect(arg).to be_nil
    end
    pass hi: 'HELLO, WORLD', sec_arg: 1 do
      expect(@_params[:hi]).to eq 'HELLO, WORLD'
      expect(@_params[:sec_arg]).to eq 1
    end
    for arg in [:hi, :sec_arg] do
      expect(@_params[arg]).to be_nil
    end
  end
end

describe 'ACU::Helpers' do
  
  let :obj { ACUHelper.new }
  
  it '.pass' do
    obj.test_protected_pass self
  end
  
end
