class Task < ApplicationRecord
  before_validation { self.title = title&.strip }
  validates :title, presence: true
end
