require_relative 'test_helper'

describe "Channel" do
  before do
    @channel = Channel.new(slack_id: "C01BKP7MWNB", name: "random", topic: "", member_count: 2)
  end

  describe "Initialize method" do
    it "it creates an instance of channel" do
      expect(@channel).must_be_kind_of Channel
    end
  end

  describe "Details method" do
    it "lists the details for a channel" do
      expect(@channel.details).must_be_kind_of Hash
    end
  end

  describe "List all method" do
    it "returns all channels in the workspace" do
      VCR.use_cassette("list_all") do
        CHANNELS_URL = "https://slack.com/api/conversations.list"
        SLACK_TOKEN = ENV["SLACK_TOKEN"]
        response = HTTParty.get(CHANNELS_URL, query: {token: SLACK_TOKEN })["channels"]
        channels = Channel.list_all
        expect(Channel.list_all.length).must_equal response.length
        response.length.times do |i|
          expect(response[i]["id"]).must_equal channels[i].slack_id
          expect(response[i]["name"]).must_equal channels[i].name
          expect(response[i]["topic"]["value"]).must_equal channels[i].topic
          expect(response[i]["num_members"]).must_equal channels[i].member_count
        end

        # NOTE: We didn't write a test to check whether the token is valid because that has already been tested in the
        # .get method in Recipient.rb from which it inherits, meaning it should work here too for channel.rb
      end
    end
  end
end
