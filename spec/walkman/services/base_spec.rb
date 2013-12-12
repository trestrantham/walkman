require "spec_helper"

describe Walkman::Services::Base do
  let(:interface) { Walkman::Services::Base.new }

  it "raises an error for all methods required by subclass" do
    expect { interface.startup }.to raise_error
    expect { interface.shutdown }.to raise_error
    expect { interface.restart }.to raise_error
    expect { interface.play("foo") }.to raise_error
    expect { interface.stop }.to raise_error
  end
end
