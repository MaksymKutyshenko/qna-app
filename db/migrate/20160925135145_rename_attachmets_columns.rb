class RenameAttachmetsColumns < ActiveRecord::Migration[5.0]
  def change
    remove_index :attachments, :attachmentable_id
    remove_index :attachments, :attachmentable_type

    rename_column :attachments, :attachmentable_id, :attachable_id
    rename_column :attachments, :attachmentable_type, :attachable_type

    add_index :attachments, :attachable_id
    add_index :attachments, :attachable_type
  end
end
