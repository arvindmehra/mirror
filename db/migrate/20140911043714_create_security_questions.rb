class CreateSecurityQuestions < ActiveRecord::Migration
  def change
    create_table :security_questions do |t|
      t.belongs_to :user, index: true
      t.string :question
      t.string :answer

      t.timestamps
    end
  end
end
