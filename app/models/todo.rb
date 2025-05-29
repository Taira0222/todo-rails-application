class Todo < ApplicationRecord
  belongs_to :user

  scope :today,    -> { where(due_at: Time.zone.today.all_day, done: false) }
  scope :upcoming, -> { where("due_at > ? AND done = ?", Time.zone.now.end_of_day, false) }
  scope :archived, -> { where(done: true) }
end
