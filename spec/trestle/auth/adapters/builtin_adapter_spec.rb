require "spec_helper"

describe Trestle::Auth::BuiltinAdapter do
  let(:admin) { double }
  let(:user) { double }

  let(:block) { Proc.new {} }

  let(:adapter_class) { Class.new(described_class) }
  subject(:adapter) { adapter_class.new(admin, user) }

  describe "#authorized?" do
    let(:instance) { double }

    context "no matching action blocks" do
      it "returns false" do
        expect(adapter.authorized?("edit", instance)).to be false
      end
    end

    context "with a matching action block" do
      before(:each) do
        adapter_class.actions["destroy"] = block
      end

      it "evaluates the action block in the context of the admin" do
        expect(admin).to receive(:instance_exec).with(instance, &block).and_return(true)
        expect(adapter.authorized?("destroy", instance)).to be true
      end
    end

    context "with a matching aliased action block" do
      before(:each) do
        adapter_class.actions["read!"] = block
      end

      it "evaluates the aliased action block in the context of the admin" do
        expect(admin).to receive(:instance_exec).with(nil, &block).and_return(true)
        expect(adapter.authorized?("index")).to be true
      end
    end

    context "with a default access block" do
      before(:each) do
        adapter_class.actions["access!"] = block
      end

      it "evaluates the access block in the context of the admin" do
        expect(admin).to receive(:instance_exec).with(instance, &block).and_return(true)
        expect(adapter.authorized?("show", instance)).to be true
      end
    end
  end

  describe "#scope" do
    let(:collection) { double }

    context "when a scope block is defined" do
      let(:scoped_collection) { double }

      before(:each) do
        adapter_class.scope = block
      end

      it "evaluates the scope block in the context of the admin" do
        expect(admin).to receive(:instance_exec).with(collection, &block).and_return(scoped_collection)
        expect(adapter.scope(collection)).to eq(scoped_collection)
      end
    end

    context "when no scope block is defined" do
      it "returns the given collection" do
        expect(adapter.scope(collection)).to eq(collection)
      end
    end
  end
end
