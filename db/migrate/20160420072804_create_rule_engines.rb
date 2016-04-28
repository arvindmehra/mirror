class CreateRuleEngines < ActiveRecord::Migration
  def change
    create_table :rule_engines do |t|
      t.string :name
      t.string :expression
      t.timestamps
    end
  end
end
