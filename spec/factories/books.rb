# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :book do
    author_id 1
    title "Moby Dick"
    isbn13 "9780679600107"
    association :author, factory: :author, first_name: "Herman", last_name: "Melville"
  end
end
