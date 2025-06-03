class Todo < ApplicationRecord
  belongs_to :user

  # listsコントローラで呼び出している
  scope :today, -> {
  where("due_at BETWEEN :start AND :end AND done = :done", 
        start: Time.zone.today.beginning_of_day, 
        end: Time.zone.today.end_of_day, 
        done: false)
  }

  scope :upcoming, -> {
    where("due_at > :end_of_today AND done = :done", 
          end_of_today: Time.zone.now.end_of_day, 
          done: false)
  }

  scope :archived, -> {
    where("due_at < :start_of_today OR done = :done", 
          start_of_today: Time.zone.now.beginning_of_day, 
          done: true)
  }
  # update 
  validates :title, presence: true, length: { maximum: 50}
  validates :description, length: { maximum: 140}
end
