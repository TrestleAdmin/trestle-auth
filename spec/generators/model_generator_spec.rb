require "spec_helper"

require "generators/trestle/auth/model/model_generator"

describe Trestle::Auth::Generators::ModelGenerator, type: :generator do
  destination File.expand_path("../../../tmp", __FILE__)

  before do
    prepare_destination
  end

  it "generates an ActiveRecord model with the default name" do
    expect(generator).to receive(:generate).with("model", "Administrator", "email:string password_digest:string first_name:string last_name:string remember_token:string remember_token_expires_at:datetime") { stub_model_file }
    run_generator
  end

  it "generates an ActiveRecord model with the specified name" do
    expect(generator(%w(TrestleAdmin))).to receive(:generate).with("model", "TrestleAdmin", "email:string password_digest:string first_name:string last_name:string remember_token:string remember_token_expires_at:datetime") { stub_model_file("TrestleAdmin") }
    run_generator %w(TrestleAdmin)
  end

  describe "the generated files" do
    before do
      allow(generator).to receive(:generate) { stub_model_file }
      run_generator
    end

    describe "the model" do
      subject { file("app/models/administrator.rb") }

      it { is_expected.to exist }
      it { is_expected.to have_correct_syntax }
      it { is_expected.to contain "include Trestle::Auth::ModelMethods" }
      it { is_expected.to contain "include Trestle::Auth::ModelMethods::Rememberable" }
    end
  end
end
