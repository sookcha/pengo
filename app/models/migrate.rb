class Migrate < ActiveRecord::Base
  has_attached_file :receipt
  do_not_validate_attachment_file_type :receipt
end
