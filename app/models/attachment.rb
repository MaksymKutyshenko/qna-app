class Attachment < ApplicationRecord
  belongs_to :attachmentable, polymorphic: true, optional: true
  mount_uploader :file, FileUploader
end
