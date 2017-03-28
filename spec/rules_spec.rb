# inject rspect defination to be test instances
class << Rules
  include ::RSpec::Matchers
end
    
describe Rules do
  context 'intro' do
    it '.define' do
      Rules.define do
        expect(self).to be ACU::Rules
        # before they are all nil
        expect(@_params).to be nil
      end
    end
  end
  
  context 'setting parameters' do
    it '.namespace' do
      Rules.define do
        namespace :foo do
          expect(@_params[:namespace]).to be_a Hash
          expect(@_params[:namespace].length).to be 3
          expect(@_params[:namespace]).to include :name, :except, :only
          expect(@_params[:namespace][:name]).to be :foo
          expect([@_params[:namespace][:except], @_params[:namespace][:only]]).to all be_nil
        end
        # after they are all nil
        expect([@_params[:namespace], @_params[:controller], @_params[:action]]).to all be_nil
      end
    end
    it '.controller' do
      Rules.define do
        controller :bar do
          expect(@_params[:controller]).to be_a Hash
          expect(@_params[:controller].length).to be 3
          expect(@_params[:controller]).to include :name, :except, :only
          expect(@_params[:controller][:name]).to be :bar
          expect([@_params[:controller][:except], @_params[:controller][:only]]).to all be_nil
        end
        # after they are all nil
        expect([@_params[:namespace], @_params[:controller], @_params[:action]]).to all be_nil
      end
    end
    it '.action' do
      Rules.define do
        action :zzz do
          expect(@_params[:action]).to be_a Hash
          expect(@_params[:action].length).to be 1
          expect(@_params[:action]).to include :name
          expect(@_params[:action][:name]).to be :zzz
        end
        # after they are all nil
        expect([@_params[:namespace], @_params[:controller], @_params[:action]]).to all be_nil
      end
    end
    it '.namespace.controller' do
      Rules.define do
        namespace :foo do
          controller :bar do
            expect(@_params[:action]).to be_nil
            expect(@_params[:namespace][:name]).to eq :foo
            expect(@_params[:controller][:name]).to eq :bar
          end
        end
      end
    end
    it '.namespace.action' do
      Rules.define do
        namespace :foo do
          action :bar do
            expect(@_params[:controller]).to be_nil
            expect(@_params[:namespace][:name]).to eq :foo
            expect(@_params[:action][:name]).to eq :bar
          end
        end
      end
    end
    it '.controller.action' do
      Rules.define do
        controller :foo do
          action :bar do
            expect(@_params[:namespace]).to be_nil
            expect(@_params[:controller][:name]).to eq :foo
            expect(@_params[:action][:name]).to eq :bar
          end
        end
      end
    end
    it '.namespace.controller.action' do
      Rules.define do
        namespace :foo do
          controller :bar do
            action :zzz do
              expect(@_params[:namespace][:name]).to eq :foo
              expect(@_params[:controller][:name]).to eq :bar
              expect(@_params[:action][:name]).to eq :zzz
            end
          end
        end
      end
    end
    it '{ namespace and controller accepts `except` & `only` }' do
      Rules.define do
        expect { namespace :foo, only: [:aaa], except: [:bbb] }.to raise_error(AmbiguousRule, 'cannot have both `only` and `except` options at the same time for namespace `foo`');
        expect { controller :foo, only: [:aaa], except: [:bbb] }.to raise_error(AmbiguousRule, 'cannot have both `only` and `except` options at the same time for controller `foo`');
        namespace :foo do
          controller :bar, except: [:ce1, :ce2, :ce3] do
            for type, info in {namespace: {name: :foo, el: 0, ol: 0}, controller: {name: :bar, el: 3, ol: 0}}
              expect(@_params[type]).to be_a Hash
              expect(@_params[type].length).to be 3
              expect(@_params[type]).to include :name, :except, :only
              expect(@_params[type][:name]).to be info[:name]
              expect((@_params[type][:except] || []).length).to be info[:el]
              expect((@_params[type][:only] || []).length).to be info[:ol]
            end
          end
        end
      end
    end
  end
  
  context 'defining entities' do
    it '.define' do
      Rules.define do
        whois :admin, args: [:var1, :var2] do
          pass
        end
      end
      expect(Rules.entities).to include :admin
      for key in [:args, :callback] do
        expect(Rules.entities[:admin]).to include key
      end
      expect(Rules.entities[:admin][:args].length).to eq 2
      expect(Rules.entities[:admin][:callback]).to be_a Proc
    end
    it '{ maintains the previous definitions }' do
      Rules.define do
        whois :guest do
          true
        end
        whois :enemy do
          false
        end
      end
      expect(Rules.entities.length).to be 3
      for entity in [:admin, :guest, :enemy] do
        expect(Rules.entities).to include entity
      end
    end 
  end
  
  context 'add rules' do
    context '.build_rule_entry' do
      it '{ invalid input }' do 
        Rules.define do
          # when there is not input defined for building entry it should fail
          expect { build_rule_entry }.to raise_error(AmbiguousRule, 'invalid input')
          namespace :bar, except: [:kkk] do
            expect { controller :zzz }.to raise_error(AmbiguousRule, /there is already an `except` or `only` constraints defined in container namespace/)
          end
          controller :bar, only: [:kkk] do
            expect { action :zzz }.to raise_error(AmbiguousRule, /there is already an `except` or `only` constraints defined in container controller/)
          end
        end
      end
      it '{ valid data }' do
        Rules.define do
          namespace :bar do
            controller :zzz do
              # this should be ok without any exception to be raised
              build_rule_entry
            end
          end
          namespace :bar do
            controller :kkk do
              action :aaa do
                # this should be ok without any exception to be raised
                build_rule_entry
              end
            end
          end
          namespace :foo do
            controller :bar, only: [:zzz] do
              # this should be ok without any exception to be raised
              build_rule_entry
            end
            controller :baz, except: [:zzz] do
              # this should be ok without any exception to be raised
              build_rule_entry
            end
          end
        end
      end
      it '{ returns valid entries }' do
        Rules.define do
          namespace :foo do
            expect(build_rule_entry).to contain_exactly :namespace
          end
          controller :foo do
            expect(build_rule_entry).to contain_exactly :controller
          end
          action :foo do
            expect(build_rule_entry).to contain_exactly :action
          end
          namespace :foo do
            controller :bar do
              expect(build_rule_entry == [:namespace, :controller]).to be true 
            end
          end
          namespace :foo do
            action :zzz do
              expect(build_rule_entry == [:namespace, :action]).to be true
            end
          end
          controller :foo do
            action :zzz do
              expect(build_rule_entry == [:controller, :action]).to be true
            end
          end
          namespace :foo do
            controller :bar do
              action :zzz do
                expect(build_rule_entry == [:namespace, :controller, :action]).to be true
              end
            end
          end
        end
      end
    end
    context '.build_rule' do
      it '{ it should create suitable hash tree as .build_rule_entry suggestes }' do
        Rules.define do
          namespace :foo do
            controller :bar do
              action :zzz do
                build_rule({rule: :admin})
              end
              action :kkk do
                build_rule({rule: :client})
              end
            end
          end
          
          controller :bar do
            action :zzz do
              build_rule( {rule: :admin})
            end
            action :kkk do
              build_rule( {rule: :client})
            end
          end
          ap rules, indent: 2
        end
      end
    end
  end
  context 'extro' do
    it '.reset' do
      expect(Rules.entities.length).not_to be_zero
      Rules.reset
      expect(Rules.entities.length).to be_zero
    end
    it '.lock' do
      Rules.lock
      expect(Rules.frozen?).to be true
      expect { Rules.reset }.to raise_error(RuntimeError, "can't modify frozen #<Class:ACU::Rules>")
    end
  end
end