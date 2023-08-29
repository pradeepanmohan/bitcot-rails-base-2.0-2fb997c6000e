class Message < ApplicationRecord
	audited
	has_paper_trail
	validates :body, presence: true, allow_blank: false

end
