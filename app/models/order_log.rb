class OrderLog < ApplicationRecord
  enum indicator_type: {
    all_submissions: 0,
    accepted_submissions: 1,
    all_submission_resources: 2,
    accepted_submission_resources: 3,
    form_field_range_levels: 4
  }
end
