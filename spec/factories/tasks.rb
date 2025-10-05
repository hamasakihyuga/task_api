# spec/factories/tasks.rb
FactoryBot.define do
  factory :task do
    title { "Sample Task" }
    description { "Demo description" }
    due_date { Date.today + 7 }
    completed { false }

    trait :completed do
      completed { true }
    end
  end
end
