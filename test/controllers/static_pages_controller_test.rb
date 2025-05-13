require "test_helper"

describe StaticPagesController do
  it "gets home" do
    get static_pages_home_url
    must_respond_with :success
  end
end
