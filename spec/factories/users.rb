# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    username { SecureRandom.hex(10) }
    is_admin { false }
  end
end
