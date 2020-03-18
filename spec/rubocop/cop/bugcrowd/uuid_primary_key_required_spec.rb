# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Bugcrowd::UuidPrimaryKeyRequired do
  subject(:cop) { described_class.new(config) }

  let(:config) { RuboCop::Config.new }

  context 'within up method' do
    context 'when creating a table with a uuid pk' do
      it 'does not register an offence' do
        expect_no_offenses(<<~RUBY)
          def up
            create_table :new_table, id: :uuid do |t|
              t.text :name, null: false
            end
          end
        RUBY
      end
    end

    context 'when creating a table with an integer pk' do
      it 'registers an offense' do
        expect_offense(<<~RUBY)
          def up
            create_table :new_table, id: :integer do |t|
            ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ All tables should all have a primary key of type :uuid
              t.text :name, null: false
            end
          end
        RUBY
      end
    end

    context 'when creating a table with a bigint (default) pk' do
      it 'registers an offense' do
        expect_offense(<<~RUBY)
          def up
            create_table :new_table do |t|
            ^^^^^^^^^^^^^^^^^^^^^^^ All tables should all have a primary key of type :uuid
              t.text :name, null: false
            end
          end
        RUBY
      end
    end
  end

  context 'within change method' do
    context 'when creating a table with a uuid pk' do
      it 'does not register an offence' do
        expect_no_offenses(<<~RUBY)
          def change
            create_table :new_table, id: :uuid do |t|
              t.text :name, null: false
            end
          end
        RUBY
      end
    end

    context 'when creating a table with an integer pk' do
      it 'registers an offense' do
        expect_offense(<<~RUBY)
          def change
            create_table :new_table, id: :integer do |t|
            ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ All tables should all have a primary key of type :uuid
              t.text :name, null: false
            end
          end
        RUBY
      end
    end

    context 'when creating a table with a bigint (default) pk' do
      it 'registers an offense' do
        expect_offense(<<~RUBY)
          def change
            create_table :new_table do |t|
            ^^^^^^^^^^^^^^^^^^^^^^^ All tables should all have a primary key of type :uuid
              t.text :name, null: false
            end
          end
        RUBY
      end
    end
  end
end
