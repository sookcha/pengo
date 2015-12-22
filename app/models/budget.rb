class Budget < ActiveRecord::Base
  scope :recents, -> {
    where("created_at > ?", Time.now-14.days)
  }
end
