# frozen_string_literal: true

RSpec.describe RailsUtils::Form, type: :model do
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

  describe "support shoulda matchers" do
    class DummyUser < described_class
      extend Enumerize

      field :username, :string
      field :age, :integer
      field :height, :float
      field :weight, :float
      field :gender, :integer
      field :occupations
      field :password, :string
      field :password_confirmation, :string

      enumerize :gender, in: %i[male female]
      enumerize :occupations, in: %i[dev ai cs other], multiple: true

      validates :username, presence: true, format: { with: /\A[a-z]+\Z/, allow_blank: true }
      validates :age, numericality: { greater_than: 0, only_integer: true, allow_nil: true, less_than_or_equal_to: 200 }
      validates :height, numericality: { greater_than: 0, allow_nil: true }
      validates :occupations, length: { is: 1, if: -> { occupations.other? } }
      validates :password, confirmation: true
      validates(
        :password_confirmation,
        presence: { if: -> { password.present? } },
        absence: { if: -> { password.blank? } }
      )
    end

    subject { DummyUser.new }

    it { is_expected.to validate_presence_of(:username) }
    it { is_expected.to allow_value("username").for(:username) }
    it { is_expected.not_to allow_value("1234").for(:username) }

    it do
      is_expected
        .to validate_numericality_of(:age).allow_nil.only_integer.is_greater_than(0).is_less_than_or_equal_to(200)
    end

    it do
      is_expected
        .to validate_numericality_of(:height).allow_nil.is_greater_than(0)
    end

    it { is_expected.to allow_value([:other]).for(:occupations) }
    it { is_expected.to allow_value(%i[dev cs ai]).for(:occupations) }
    it { is_expected.not_to allow_value(%i[dev cs other]).for(:occupations) }

    it { is_expected.to validate_confirmation_of(:password) }

    describe "#password_confirmation" do
      context "when password present" do
        subject { DummyUser.new(password: "123") }

        it { is_expected.to validate_presence_of(:password_confirmation) }
      end

      context "when password blank" do
        subject { DummyUser.new(password: "") }

        it { is_expected.to validate_absence_of(:password_confirmation) }
      end
    end
  end
end
