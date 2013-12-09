require "spec_helper"

describe Walkman::Service::Base do
  let(:interface) { Walkman::Service::Base.new }

  it "raises an error for all methods required by subclass" do
    expect { interface.startup }.to raise_error
    expect { interface.shutdown }.to raise_error
    expect { interface.restart }.to raise_error
    expect { interface.play }.to raise_error
    expect { interface.stop }.to raise_error
  end
end
