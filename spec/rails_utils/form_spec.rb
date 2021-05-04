# frozen_string_literal: true

RSpec.describe RailsUtils::Form do
  class SignUpForm < described_class
    field :email, type: :string

    validates :email, presence: true
  end

  let(:form) { SignUpForm.new(attrs) }
  let(:attrs) { {} }

  describe "validations" do
    subject { form }

    context "when email is invalid" do
      let(:attrs) { { email: "" } }

      it { is_expected.to be_invalid }
    end

    context "when email is valid" do
      let(:attrs) { { email: "user@example.com" } }

      it { is_expected.to be_valid }
    end
  end
end
