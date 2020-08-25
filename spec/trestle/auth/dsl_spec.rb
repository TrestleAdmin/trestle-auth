require "spec_helper"

describe Trestle::Auth::DSL do
  subject(:dsl) { described_class.new }

  let(:adapter) { dsl.adapter }

  describe "#scope" do
    it "sets the scope block on the adapter class" do
      block = Proc.new {}

      dsl.build do
        scope &block
      end

      expect(adapter.scope).to eq(block)
    end
  end

  describe "#actions" do
    it "sets the actions on the adapter class to the given block" do
      block = Proc.new {}

      dsl.build do
        actions "update", "destroy", &block
      end

      expect(adapter.actions["update"]).to eq(block)
      expect(adapter.actions["destroy"]).to eq(block)
    end
  end

  describe "#access!" do
    it "defines a catch-all access block" do
      block = Proc.new {}

      dsl.build do
        access! &block
      end

      expect(adapter.actions["access!"]).to eq(block)
    end
  end

  describe "defining action blocks" do
    it "defines an action block using methods ending with ?" do
      block = Proc.new {}

      dsl.build do
        show? &block
      end

      expect(adapter.actions["show"]).to eq(block)
    end

    it "raises NoMethodError for any other methods" do
      block = Proc.new {}

      expect do
        dsl.build do
          invalid! &block
        end
      end.to raise_error(NoMethodError)
    end
  end
end
