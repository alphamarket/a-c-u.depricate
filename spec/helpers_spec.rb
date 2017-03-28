class ACUHelper
  include ACU::Helpers
  def test_protected_pass rspec
    for arg in [@hi, @sec_arg] do
      rspec.expect(arg).to rspec.be_nil
    end
    pass hi: 'HELLO, WORLD', sec_arg: 1 do
      rspec.expect(@hi).to rspec.eq 'HELLO, WORLD'
      rspec.expect(@sec_arg).to rspec.eq 1
    end
    for arg in [@hi, @sec_arg] do
      rspec.expect(arg).to rspec.be_nil
    end
  end
end

describe ACUHelper do
  
  let :obj { ACUHelper.new }
  
  it 'passes the params to the block' do
    obj.test_protected_pass self
  end
  
end
