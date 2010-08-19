require File.expand_path(File.dirname(__FILE__) + "/spec_helper")
require File.expand_path(File.dirname(__FILE__) + "/models/topic")

require "active_record/fixtures"

describe Arrcc, "ActiveRecord model counter cache" do
  Fixtures.create_fixtures "#{File.dirname(__FILE__)}/fixtures", [:topics, :categories, :categorizations, :cars]

  before :all do
    @topic = Topic.find(1)
  end

  it "increments counter" do
    redis = mock("Redis")
    Redis.stub!(:initialize).and_return redis

    redis.should_receive(:incr).with "arrcc:topic:#{@topic.id}", 1

    proc {
      Topic.increment_counter(:replies_count, @topic.id)
    }.should change(@topic, :replies_count)
  end

  # test "increment counter" do
  #   assert_difference '@topic.reload.replies_count' do
  #     Topic.increment_counter(:replies_count, @topic.id)
  #   end
  # end

  # test "decrement counter" do
  #   assert_difference '@topic.reload.replies_count', -1 do
  #     Topic.decrement_counter(:replies_count, @topic.id)
  #   end
  # end
  #
  # test "reset counters" do
  #   # throw the count off by 1
  #   Topic.increment_counter(:replies_count, @topic.id)
  #
  #   # check that it gets reset
  #   assert_difference '@topic.reload.replies_count', -1 do
  #     Topic.reset_counters(@topic.id, :replies)
  #   end
  # end
  #
  # test "reset counters with string argument" do
  #   Topic.increment_counter('replies_count', @topic.id)
  #
  #   assert_difference '@topic.reload.replies_count', -1 do
  #     Topic.reset_counters(@topic.id, 'replies')
  #   end
  # end
  #
  # test "reset counters with modularized and camelized classnames" do
  #   special = SpecialTopic.create!(:title => 'Special')
  #   SpecialTopic.increment_counter(:replies_count, special.id)
  #
  #   assert_difference 'special.reload.replies_count', -1 do
  #     SpecialTopic.reset_counters(special.id, :special_replies)
  #   end
  # end
  #
  # test "reset counter should with belongs_to which has class_name" do
  #   car = cars(:honda)
  #   assert_nothing_raised do
  #     Car.reset_counters(car.id, :engines)
  #   end
  #   assert_nothing_raised do
  #     Car.reset_counters(car.id, :wheels)
  #   end
  # end
  #
  # test "update counter with initial null value" do
  #   category = categories(:general)
  #   assert_equal 2, category.categorizations.count
  #   assert_nil category.categorizations_count
  #
  #   Category.update_counters(category.id, :categorizations_count => category.categorizations.count)
  #   assert_equal 2, category.reload.categorizations_count
  # end
  #
  # test "update counter for decrement" do
  #   assert_difference '@topic.reload.replies_count', -3 do
  #     Topic.update_counters(@topic.id, :replies_count => -3)
  #   end
  # end
  #
  # test "update counters of multiple records" do
  #   t1, t2 = topics(:first, :second)
  #
  #   assert_difference ['t1.reload.replies_count', 't2.reload.replies_count'], 2 do
  #     Topic.update_counters([t1.id, t2.id], :replies_count => 2)
  #   end
  # end
end

# describe Arrcc, "for belongs to association" do
#   def test_counter_cache
#     topic = Topic.create :title => "Zoom-zoom-zoom"
#     assert_equal 0, topic[:replies_count]
#
#     reply = Reply.create(:title => "re: zoom", :content => "speedy quick!")
#     reply.topic = topic
#
#     assert_equal 1, topic.reload[:replies_count]
#     assert_equal 1, topic.replies.size
#
#     topic[:replies_count] = 15
#     assert_equal 15, topic.replies.size
#   end
#
#   def test_custom_counter_cache
#     reply = Reply.create(:title => "re: zoom", :content => "speedy quick!")
#     assert_equal 0, reply[:replies_count]
#
#     silly = SillyReply.create(:title => "gaga", :content => "boo-boo")
#     silly.reply = reply
#
#     assert_equal 1, reply.reload[:replies_count]
#     assert_equal 1, reply.replies.size
#
#     reply[:replies_count] = 17
#     assert_equal 17, reply.replies.size
#   end
# end
#
# describe Arrcc, "for has many association" do
#   def test_deleting_updates_counter_cache
#     topic = Topic.first(:order => "id ASC")
#     assert_equal topic.replies.to_a.size, topic.replies_count
#
#     topic.replies.delete(topic.replies.first)
#     topic.reload
#     assert_equal topic.replies.to_a.size, topic.replies_count
#   end
#
#   def test_deleting_updates_counter_cache_without_dependent_destroy
#     post = posts(:welcome)
#
#     assert_difference "post.reload.taggings_count", -1 do
#       post.taggings.delete(post.taggings.first)
#     end
#   end
#
#   def test_clearing_updates_counter_cache
#     topic = Topic.first
#
#     topic.replies.clear
#     topic.reload
#     assert_equal 0, topic.replies_count
#   end
# end
#
# describe Arrcc, "for join model" do
#   def test_belongs_to_polymorphic_with_counter_cache
#     assert_equal 1, posts(:welcome)[:taggings_count]
#     tagging = posts(:welcome).taggings.create(:tag => tags(:general))
#     assert_equal 2, posts(:welcome, :reload)[:taggings_count]
#     tagging.destroy
#     assert_equal 1, posts(:welcome, :reload)[:taggings_count]
#   end
#
#   def test_has_many_through_collection_size_uses_counter_cache_if_it_exists
#     author = authors(:david)
#     author.stubs(:read_attribute).with('comments_count').returns(100)
#     assert_equal 100, author.comments.size
#     assert !author.comments.loaded?
#   end
# end
#
# describe Arrcc, "for timestamps" do
#   def test_touching_a_record_with_a_belongs_to_that_uses_a_counter_cache_should_update_the_parent
#     Pet.belongs_to :owner, :counter_cache => :use_count, :touch => true
#
#     pet = Pet.first
#     owner = pet.owner
#     owner.update_attribute(:happy_at, (time = 3.days.ago))
#     previously_owner_updated_at = owner.updated_at
#
#     pet.name = "I'm a parrot"
#     pet.save
#
#     assert_not_equal previously_owner_updated_at, pet.owner.updated_at
#   ensure
#     Pet.belongs_to :owner, :touch => true
#   end
# end