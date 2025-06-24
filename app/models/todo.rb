class Todo < ApplicationRecord
  belongs_to :user
  before_validation :merge_due_date_and_time

  attr_accessor :due_date, :due_time, :request_token

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
  validate :prevent_double_submission, on: :create

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

    # 二重の作成を防ぐメソッド
    def prevent_double_submission
      # request_token がなければ何もしない
      return unless request_token.present?

      key = cache_key_for(request_token)

      if Rails.cache.exist?(key)
        errors.add(:base, "二重送信を検出しました。作成ボタンは1回のみ押してください")
      else
        Rails.cache.write(key, true, expires_in: 5.minutes)
      end
    end

    # 名前空間付きkeyを作成
    def cache_key_for(token)
      "todo:request_token:#{token}"
    end
end
