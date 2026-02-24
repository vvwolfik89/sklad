require 'test_helper'

class JournalTest < ActiveSupport::TestCase
  setup do
    @journal = Journal.new(title: 'Test Journal')
  end

  test 'should be valid with valid attributes' do
    assert @journal.valid?, 'Journal with title should be valid'
  end

  test 'should not be valid without title' do
    @journal.title = nil
    assert_not @journal.valid?, 'Journal without title should be invalid'
    assert_includes @journal.errors[:title], 'can\'t be blank'
  end

  test 'should have many fields' do
    assert_respond_to @journal, :fields
    assert_equal [], @journal.fields.to_a
  end

  test 'should have many entries' do
    assert_respond_to @journal, :entries
    assert_equal [], @journal.entries.to_a
  end

  test 'should have many schedules' do
    assert_respond_to @journal, :schedules
    assert_equal [], @journal.schedules.to_a
  end

  test 'should destroy associated fields when journal is destroyed' do
    journal = Journal.create!(title: 'Test')
    field = journal.fields.create!(name: 'Test Field', field_type: "text")

    assert_difference 'Field.count', -1 do
      journal.destroy
    end
  end

  test 'should destroy associated entries when journal is destroyed' do
    journal = Journal.create!(title: 'Test')
    entry = journal.entries.create!(date: Date.today, creator: users(:superadmin) )

    assert_difference 'Entry.count', -1 do
      journal.destroy
    end
  end

  test 'should destroy associated schedules when journal is destroyed' do
    journal = Journal.create!(title: 'Test')
    schedule = journal.schedules.create!

    assert_difference 'Schedule.count', -1 do
      journal.destroy
    end
  end

  test 'accepts nested attributes for fields' do
    assert @journal.respond_to?(:fields_attributes=)
  end

  test 'allows destroying fields through nested attributes' do
    journal = Journal.create!(title: 'Test')
    field = journal.fields.create!(name: 'Field to delete', field_type: "text")

    attributes = [{ id: field.id, _destroy: '1' }]
    journal.update(fields_attributes: attributes)

    assert_nil journal.fields.find_by(id: field.id)
  end

  test 'rejects blank field names in nested attributes' do
    journal = Journal.create!(title: 'Test')
    invalid_attributes = [{ name: '' }, { name: 'Valid Field', field_type: "text" }]

    journal.update(fields_attributes: invalid_attributes)

    assert_equal 1, journal.fields.count
    assert_equal 'Valid Field', journal.fields.first.name
  end

  test 'creates fields with valid nested attributes' do
    journal_attributes = {
      title: 'Test Journal',
      fields_attributes: [
        { name: 'Field 1', field_type: "text"},
        { name: 'Field 2', field_type: "text"}
      ]
    }

    journal = Journal.create!(journal_attributes)
    assert_equal 2, journal.fields.count
    assert_includes journal.fields.map(&:name), 'Field 1'
    assert_includes journal.fields.map(&:name), 'Field 2'
  end

  test 'related_versions returns journal versions' do
    journal = Journal.create!(title: 'Test')
    PaperTrail::Version.create!(item: journal, event: 'create')

    versions = journal.related_versions
    assert_includes versions.map(&:item_id), journal.id
    assert_includes versions.map(&:item_type), 'Journal'
  end

  test 'related_versions returns field versions' do
    journal = Journal.create!(title: 'Test')
    field = journal.fields.create!(name: 'Test Field', field_type: "text")
    PaperTrail::Version.create!(item: field, event: 'create')

    versions = journal.related_versions
    assert_includes versions.map(&:item_id), field.id
    assert_includes versions.map(&:item_type), 'Field'
  end

  test 'related_versions combines journal and field versions' do
    journal = Journal.create!(title: 'Test')
    journal_version = PaperTrail::Version.create!(item: journal, event: 'create')

    field = journal.fields.create!(name: 'Test Field', field_type: "text")
    field_version = PaperTrail::Version.create!(item: field, event: 'create')

    versions = journal.related_versions

    assert_includes versions, journal_version
    assert_includes versions, field_version
    assert_equal 4, versions.size
  end

  test 'related_versions sorts versions by created_at' do
    journal = Journal.create!(title: 'Test')

    # Создаём версии с разными временными метками
    old_version = PaperTrail::Version.create!(
      item: journal,
      event: 'create',
      created_at: 2.days.ago
    )

    new_version = PaperTrail::Version.create!(
      item: journal,
      event: 'update',
      created_at: 1.day.ago
    )

    versions = journal.related_versions
    assert_equal old_version, versions[0]
    assert_equal new_version, versions[1]
  end

  test 'related_versions handles nil created_at gracefully' do
    journal = Journal.create!(title: 'Test')

    version_with_time = PaperTrail::Version.create!(
      item: journal,
      event: 'create',
      created_at: Time.current
    )

    version_without_time = PaperTrail::Version.create!(
      item: journal,
      event: 'update',
      created_at: nil
    )

    versions = journal.related_versions
    # Версия с nil created_at должна быть первой (Time.at(0))
    assert_equal version_without_time, versions[2]
    assert_equal version_with_time, versions[1]
  end

  test 'full lifecycle with nested attributes and versions' do
    journal_attributes = {
      title: 'Complete Test Journal',
      fields_attributes: [
        { name: 'First Field', field_type: "text" },
        { name: 'Second Field', field_type: "text" }
      ]
    }

    journal = Journal.create!(journal_attributes)

    # Проверяем создание
    assert_equal 'Complete Test Journal', journal.title
    assert_equal 2, journal.fields.count

    # Обновляем
    update_attributes = {
      title: 'Updated Journal',
      fields_attributes: [
        { id: journal.fields.first.id, name: 'Updated Field', field_type: "text" },
        { name: 'New Field', field_type: "text" }
      ]
    }
    journal.update!(update_attributes)

    # Проверяем версии
    versions = journal.related_versions
    assert versions.any? { |v| v.event == 'create' }
    assert versions.any? { |v| v.event == 'update' }
    assert versions.size >= 3 # create + 2 updates
  end
end
