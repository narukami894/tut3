class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def expired?(sent_at, deadline)
    sent_at < deadline
  end
end
