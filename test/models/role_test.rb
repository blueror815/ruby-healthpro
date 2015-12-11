require 'test_helper'

class RoleTest < ActiveSupport::TestCase
  test 'should return right roles' do
    assert_equal(%w(user admin hr), Role.user_roles)
  end

  test 'should return wrong roles' do
    assert_not_equal(['user'], Role.user_roles)
  end

  test 'add role without name' do
    role = Role.new
    assert_not role.save
  end
end
