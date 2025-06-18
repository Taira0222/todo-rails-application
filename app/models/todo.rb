class Todo < ApplicationRecord
  belongs_to :user
  before_validation :merge_due_date_and_time

  attr_accessor :due_date, :due_time # 仮想属性として due_at, due_time を設定

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
  validates :title, presence: true, length: { maximum: 50 }
  validates :description, length: { maximum: 140 }
  validates :due_at, presence: true
  validates :due_time, presence: true, if: :has_time? # has_time がtrueの時のみバリデーション

  private
    def merge_due_date_and_time
      # doneボタンなど入力しない場合にエラーにならない対策
      return unless due_date
      # 日付の23:59:59をデフォルトタイムスタンプとする
      # 日付が変わるまで today or upcoming のtodo が移動しなくなる
      timestamp = due_date.in_time_zone.beginning_of_day
      if has_time?
        if due_time.present?
          # 時間,分をそれぞれhour,min に代入
          hour, min = due_time.split(":").map(&:to_i)
          timestamp = timestamp.change(hour: hour, min: min)
        end
        # due_time が空なら「23:59:59」のまま
      end
      self.due_at = timestamp
    end
end
