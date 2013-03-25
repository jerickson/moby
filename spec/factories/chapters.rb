# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :chapter do
    name "Chaper 1. Loomings"
    position 1
    association :book
  end
end
